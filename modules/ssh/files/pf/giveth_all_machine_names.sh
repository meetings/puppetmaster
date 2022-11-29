#!/bin/bash

DIR=$(dirname $0)
CFG=conf/provided_services.config

cat $DIR/$CFG |grep ' 22'|grep -v '\-a '|awk '$1 !~ "#" {print $3}'
