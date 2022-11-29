#!/bin/sh
df / | awk 'NR>1 && $5+0>90 {print $1, $5}'
