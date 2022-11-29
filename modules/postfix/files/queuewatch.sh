#!/bin/bash
#
# 2013-12-04 / Meetin.gs
#
# Alert if mail queue is not empty.

PATH=/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH

le_fu() {
    sms "$(hostname): $@"
    exit
}

do_check() {
    MSG=$(mailq) || le_fu "mailq failed"
    [ "$MSG" == "Mail queue is empty" ] && exit
}

do_check

### Continue here only if there was something in mail queue!

# Try to flush queue. It may help.
postfix flush

# Wait arbitrarily. Maybe problems disappear.
sleep 42

do_check

# There really is something in the queue and its not leaving :-(

le_fu "mail queue not empty"
