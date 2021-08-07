#!/bin/sh
#
# Client for Common Lisp Server

# TODO To support options "--help", "--script", "--verbose",
# "--version". Support quick launching core image if server
# happens to be down.

# TODO Rewrite this client in C.. shell is stil TOO slow. Need to
# hack cl-unix-sockets. Compare with the tests in
# https://www.reddit.com/r/Common_Lisp/comments/owgrie/ways_to_talk_to_a_lisp_repl_a_brief_survey/
#
# TODO Add an option "--script" that takes a file and treats its
# content as ARGV.

escape () {
    echo "$@" | sed 's/\\/\\\\\\\\/g' | sed 's/\"/\\\"/g'
}

STDIN=$([ ! -t 0 ] && cat -)
ARGS=$(escape "$@")
UNIX_TIME=$(date +%s)
ID=$RANDOM$RANDOM$RANDOM
LISTEN_ON="/tmp/$ID"

generate_parcel () {
    echo -e "("
    echo -e ""
    echo -e " :STDIN\n\n \"$STDIN\"\n"
    echo -e " :ARGS\n\n \"$ARGS\"\n"
    echo -e " :UNIX-TIME\n\n \"$UNIX_TIME\"\n"
    echo -e " :ID\n\n \"$ID\"\n"
    echo -e ")"
    echo -e ""
}
PARCEL=$(generate_parcel)
# Verbose
# # TODO Add an option "--verbose"
# echo -e "                " 1>&2
# echo -e "     .-****-.   " 1>&2
# echo -e "    *       _*  " 1>&2
# echo -e "   * EVAL .'  * " 1>&2
# echo -e "   *.___.'    * " 1>&2
# echo -e "   '.   APPLY.' " 1>&2
# echo -e "     *.____.*   " 1>&2
# echo -e "                " 1>&2
# echo -e "$PARCEL"          1>&2

SOCKETS_DIR="/home/jin/.cl-server/sockets"
SOCKET=$(ls "$SOCKETS_DIR" | sort -r | head -n 1)
echo "$PARCEL" | socat - UNIX-CONNECT:"$SOCKETS_DIR/$SOCKET"
# TODO If the server is not on, say something and skip the next step.

# echo speeds up socat's ending decision when stdin is empty.
# FIXME - The result should be printed readably by lisp?
echo | socat UNIX-LISTEN:$LISTEN_ON -

exit
