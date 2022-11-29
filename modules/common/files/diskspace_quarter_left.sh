#!/bin/sh
df / | awk 'NR>1 && $5+0>75 {print $1, $5}'
