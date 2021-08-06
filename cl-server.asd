#-asdf3.1 (error "Requires ASDF 3.1+")

(asdf:defsystem "cl-server"
  :description "Common Lisp Server"
  :author "Jin-Cheng Guu <jcguu95@gmail.com>"
  :licence "MIT"
  :version "0.0"
  :properties ((#:author-email . "jcguu95@gmail.com"))
  #+asdf-unicode :encoding #+asdf-unicode :utf-8
  :depends-on (:unix-sockets :babel :bordeaux-threads :local-time)
  :components ((:file "package")
               (:file "cl-server")))
