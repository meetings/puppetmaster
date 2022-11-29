#!/usr/bin/python
# -*- coding: utf-8 -*-
# vim: set sw=4 ts=4 sts=4 expandtab

from json import dumps

def tail(n=100):
    """ Read last n lines from auth.log """
    with open("/var/log/auth.log") as f:
        BUF = 4096
        f.seek(0, 2)
        bytes = f.tell()
        size = n
        block = -1
        data = []
        while size > 0 and bytes > 0:
            if (bytes-BUF > 0):
                f.seek(block*BUF, 2)        # seek back
                data.append(f.read(BUF))    # read
            else:
                f.seek(0,0)                 # file too small
                data.append(f.read(bytes))  # read unread
            linesFound = data[-1].count('\n')
            size -= linesFound
            bytes -= BUF
            block -= 1
    return ''.join(data).splitlines()[-n:]

if __name__ == "__main__":
    with open("/tmp/authlog.json", "w") as out:
        out.write("window.authlog = " + dumps(tail()))
