#!/bin/bash

CFG=conf/fronts.config
DIR=$(dirname $0)

# Assume dom0 names start with an alphabet
# to filter out comments and empty lines.
awk '/^[a-z]/{print$1}' $DIR/$CFG
