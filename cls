#!/bin/sh
#
# Client for Common Lisp Server (CLS)

# TODO To support options "--help", "--script", "--verbose",
# "--version". Support quick launching core image if server
# happens to be down.

escape () {
    echo "$@" | sed 's/\\/\\\\\\\\/g' | sed 's/\"/\\\"/g'
}

STDIN=$(escape "$(cat -)") # FIXME - If no input, it hangs and waits.
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
# # Verbose
# echo -e "                " 1>&2
# echo -e "     .-****-.   " 1>&2
# echo -e "    *       _*  " 1>&2
# echo -e "   * EVAL .'  * " 1>&2
# echo -e "   *.___.'    * " 1>&2
# echo -e "   '.   APPLY.' " 1>&2
# echo -e "     *.____.*   " 1>&2
# echo -e "                " 1>&2
# echo -e "$PARCEL"          1>&2 # FIXME - It should be printed readably.

SOCKETS_DIR="/home/jin/.cl-server/sockets"
SOCKET=$(ls "$SOCKETS_DIR" | sort -r | head -n 1)
echo "$PARCEL" | socat - UNIX-CONNECT:"$SOCKETS_DIR/$SOCKET"

#socat UNIX-LISTEN:$LISTEN_ON,fork - #&&# rm $LISTEN_ON
socat UNIX-LISTEN:$LISTEN_ON - #&& rm $LISTEN_ON

exit
