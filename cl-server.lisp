(in-package :cl-server)

(defparameter *servers* nil)
(defparameter *parcels* nil)
(defparameter *sockets-dir* "/home/jin/.cl-server/sockets/")
(ensure-directories-exist *sockets-dir*)

;; FIXME What if the thread takes a long task? Some other thread
;; should be created, at least to inform the user.

(defun now-ts ()
  "Generate the current timestring."
  (local-time:format-timestring
   nil (local-time:now)
   :format '((:YEAR 4) (:MONTH 2) (:DAY 2) #\-
             (:HOUR 2) (:MIN 2) (:SEC 2))))

(defun all-servers ()
  "List all cl-servers."
  *servers*)

(defun start-server (&optional file)
  "Start a cl server with a UNIX socket at FILE."
  (let ((now (now-ts)))
    (unless file (setf file (format nil "~a~a" *sockets-dir* now)))
    (push
     (bt:make-thread
      (lambda ()
        (unwind-protect
             (unix-sockets:with-unix-socket
                 (server-sock (unix-sockets:make-unix-socket file))
               (loop while t
                     do (unix-sockets:with-unix-socket
                            (client (unix-sockets:accept-unix-socket server-sock))
                          (let ((read-value nil)
                                (result (list 0)) ; adhoc fix for push later
                                (stream (unix-sockets:unix-socket-stream client)))
                            (loop while (setf read-value (read-byte stream nil))
                                  do (push read-value (cdr (last result))))
                            (let* ((parcel (string-trim
                                            '(#\Soh #\Nul)
                                            (babel:octets-to-string
                                             (coerce result '(vector (unsigned-byte 8))))))
                                   (message (unpack parcel)))
                              (push parcel *parcels*)
                              (when (messagep message)
                                (bt:make-thread
                                 ;; TODO Handle errors more
                                 ;; cleverly. Otherwise the shell
                                 ;; side does not know if it
                                 ;; should keep waiting. TODO
                                 ;; Should separate eval-message
                                 ;; and return message, and tell
                                 ;; the shell side if error
                                 ;; happens.
                                 (lambda () (ignore-errors (eval-message message)))
                                 :name "please gimme a subname TODO")))))))
          (delete-file file)))
      :name (format nil "cl-server:~a" now))
     *servers*)))

(defun kill-server (&optional n)
  (if n
      (bt:destroy-thread (nth n *servers*))
      (format t "Specify the Nth server to kill in (kill-server N):~%~a"
              (loop for i from 0
                    for server in *servers*
                    collect (cons i server)))))

(defun unpack (parcel)
  ;; TODO make a generic function.
  "Expect PARCEL to be a string that satisfies the
  following: (read-from-string PARCEL) must return NIL or a plist
  with values being strings. In this case, we say that PARCEL
  unpacks to a MESSAGE."
  (read-from-string parcel nil))

(defun messagep (message)
  "A message is a plist with values being strings."
  (labels ((plist-strings? (x)
             (or (null x)
                 (progn (assert (keywordp (car x)))
                        (assert (stringp (cadr x)))
                        (assert (plist-strings? (cddr x)))
                        t))))
    (values (plist-strings? message) message)))

(defun eval-message (message
                     &key
                       stdin-transformer
                       (args-transformer (lambda (x) (read-from-string x nil))))
  ;; TODO make a generic function.
  "Evaluate the MESSAGE if it is a message."
  (assert (messagep message))
  (let ((stdin (getf message :STDIN))
        (args (getf message :ARGS))
        (unix-time (getf message :UNIX-TIME))
        (id (getf message :ID)))
    (declare (ignore unix-time))
    (when stdin-transformer
      (setf stdin (funcall stdin-transformer stdin)))
    (when args-transformer
      (setf args (funcall args-transformer args)))
    (let ((output (with-input-from-string (in stdin)
                    (let ((*standard-input* in))
                      (eval args)))))

       (with-input-from-string
           (in-stream (format nil "~a~&" output))
         (uiop:run-program
          (format nil "socat - UNIX-CONNECT:/tmp/~a" id)
          :input in-stream
          :output *standard-output*))
      ;; ;; unix-sockets only supports sending bytes currently. I
      ;; ;; do no know how to let the bytes arrive in the correct
      ;; ;; order.
      ;;
      ;; (loop for byte across (babel:string-to-octets (format nil "~a" output))
      ;;       do (unix-sockets:with-unix-socket
      ;;              (client (unix-sockets:connect-unix-socket (format nil "/tmp/~a" id)))
      ;;            (let* ((stream (unix-sockets:unix-socket-stream client)))
      ;;              ;; this does not guarantee sending in correct order
      ;;              (write-byte byte stream))))
      )))

