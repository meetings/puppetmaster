#!/bin/bash
FILE=$1
if [ -d /etc/post_decrypt_hooks.d ]
    then
    for SCRIPT in /etc/post_decrypt_hooks.d/*
    do
        if [ -f $SCRIPT -a -x $SCRIPT ]
            then
            $SCRIPT $FILE
        fi
    done
fi
