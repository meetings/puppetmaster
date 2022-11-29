#!/bin/bash

DIR=$(dirname $0)
CFG=conf/provided_services.config

awk '$1 !~ "#" && $5 == "servicepool" {print $2 "  " $1 "  " $3}' $DIR/$CFG
