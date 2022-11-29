#!/bin/bash
#
# Try to start perlbal(1p) patiently
# if it is not running already.

for I in 1 2 3 4 5; do
    pgrep perlbal >/dev/null && continue
    sleep 20
    service perlbal start
done

exit 0
