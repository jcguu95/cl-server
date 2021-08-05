(in-package :cl-server)

(defvar *file* "/home/jin/socket")
(defvar *messages* nil)

;; README
;;
;; Use the shell script client `cls` to send message to LISP.
;;
;; TODO Need to define a protocol, write a message checker, and
;; interpretor. Moreover, need to take care of the output back to
;; the client too (harder).

(defun start-server (&optional (file *file*))
  "Start a cl server with a UNIX socket at FILE."
  (bt:make-thread
   (lambda ()
     (unix-sockets:with-unix-socket (server-sock (unix-sockets:make-unix-socket file))
       (loop while t
             do (unix-sockets:with-unix-socket (client (unix-sockets:accept-unix-socket server-sock))
                  (let ((read-value nil)
                        (result (list 1)) ; adhoc fix for push later ; FIXME is it necessary?
                        (stream (unix-sockets:unix-socket-stream client)))
                    (loop while (setf read-value (read-byte stream nil))
                          do (push read-value (cdr (last result))))
                    (push (string-trim
                           '(#\Soh)
                           (babel:octets-to-string
                            (coerce result '(vector (unsigned-byte 8)))))
                          *messages*))))))
   :name "cl-server"))
