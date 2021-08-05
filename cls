#!/bin/sh
#
# Client for Common Lisp Server (CLS)

escape () {
    echo "$@" | sed 's/\\/\\\\\\\\/g' | sed 's/\"/\\\"/g'
}

UNIX_TIME=$(date +%s)
STDIN=$(escape "$(cat -)") # FIXME - If no input, it hangs and waits.
ARGS=$(escape "$@")

generate_message () {
    echo -e "("
    echo -e " :UNIX-TIME\n\n \"$UNIX_TIME\"\n"
    echo -e " :STDIN\n\n \"$STDIN\"\n"
    echo -e " :ARGS\n\n \"$ARGS\""
    echo -e ")"
    echo -e ""
}
MESSAGE=$(generate_message)

# Verbose
echo -e ""
echo -e "     .-****-.   "
echo -e "    *       _*  "
echo -e "   * EVAL .'  * "
echo -e "   *.___.'    * "
echo -e "   '.   APPLY.' "
echo -e "     *.____.*   "
echo -e ""
echo -e "$MESSAGE" # FIXME - It should be printed readably.



SOCKET="/home/jin/socket"
echo "$MESSAGE" | socat - UNIX-CONNECT:$SOCKET

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
