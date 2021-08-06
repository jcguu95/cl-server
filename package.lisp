(defpackage #:cl-server
  (:use #:cl)
  (:export #:start-server
           #:kill-server
           #:*servers*
           #:*parcels*
           #:*sockets-dir*
           #:*messages*))
