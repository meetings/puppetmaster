#!/bin/bash
# meetings_pb_role_select.sh, 2014-11-10 / Meetin.gs

nat() {
    /sbin/iptables -t nat $@
}

nat -L -n &> /dev/null
if [ $? -ne 0 ]; then
    echo
    echo Error:
    echo " Running iptables(8) failed."
    echo
    echo " Make sure you are carrying root permissions and"
    echo " that correct kernel modules are installed."
    echo
    echo " To install kernel modules:"
    echo " # apt-get install linux-image-$(uname -r)"
    echo
    exit 1
fi

if [[ "$1" == a* ]]; then
    PORT=3306
elif [[ "$1" == p* ]]; then
    PORT=3307
else
    echo
    echo Usage:
    echo " ${0##*/} <active | passive>"
    echo
    echo Error:
    echo " One parameter selecting either active or passive mode is"
    echo " required. Parameter may be abbreviated to just a or p."
    echo
    echo Status:
    echo -n " > "
    iptables -L -n -t nat | grep REDIRECT | cut -b 63-
    echo
    exit 1
fi

nat -F
nat -X
echo "33066 => $PORT"
nat -A OUTPUT --dst 127.0.0.1 -p tcp --dport 33066 -j REDIRECT --to-port $PORT

if [[ "$1" == p* ]]; then
    MYPROC="SELECT id FROM information_schema.processlist WHERE db IS NOT NULL"
    mysql -e "$MYPROC" | tail -n+2 | sed 's/^/KILL /; s/$/;/' | mysql
fi
