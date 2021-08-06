#!/bin/sh
#
# Client for Common Lisp Server (CLS)

# TODO To support options "--help", "--script", "--verbose",
# "--version". Support quick launching core image if server
# happens to be down.

escape () {
    echo "$@" | sed 's/\\/\\\\\\\\/g' | sed 's/\"/\\\"/g'
}

UNIX_TIME=$(date +%s)
STDIN=$(escape "$(cat -)") # FIXME - If no input, it hangs and waits.
ARGS=$(escape "$@")

generate_parcel () {
    echo -e "("
    echo -e " :UNIX-TIME\n\n \"$UNIX_TIME\"\n"
    echo -e " :STDIN\n\n \"$STDIN\"\n"
    echo -e " :ARGS\n\n \"$ARGS\""
    echo -e ")"
    echo -e ""
}
PARCEL=$(generate_parcel)

# Verbose
echo -e "                " 1>&2
echo -e "     .-****-.   " 1>&2
echo -e "    *       _*  " 1>&2
echo -e "   * EVAL .'  * " 1>&2
echo -e "   *.___.'    * " 1>&2
echo -e "   '.   APPLY.' " 1>&2
echo -e "     *.____.*   " 1>&2
echo -e "                " 1>&2
echo -e "$PARCEL"          1>&2 # FIXME - It should be printed readably.

SOCKETS_DIR="/home/jin/.cl-server/sockets"
SOCKET=$(ls "$SOCKETS_DIR" | sort -r | head -n 1)
echo "$PARCEL" | socat - UNIX-CONNECT:"$SOCKETS_DIR/$SOCKET"

### TODO To receive message, look into
### socat - UNIX-SENDTO:/home/jin/test
### socat - UNIX-RECVFROM:/home/jin/test

exit

# EXAMPLE
#
# $ printf "Dear Lisp, \\ \n Here is a message for ya." | ./cls "(defparameter *x* nil)"
#
#      .-****-.
#     *       _*
#    * EVAL .'  *
#    *.___.'    *
#    '.   APPLY.'
#      *.____.*
#
# (
#  :UNIX-TIME
#
#  "1628189948"
#
#  :STDIN
#
#  "Dear Lisp, \
#  Here is a message for ya."
#
#  :ARGS
#
#  "(defparameter *x* nil)"
# )
