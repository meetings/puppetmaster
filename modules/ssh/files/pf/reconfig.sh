#!/bin/bash
./build.pl
if [ ! -f ~/.ssh/config.my ]; then cp ~/.ssh/config ~/.ssh/config.my; fi
cat build/ssh_config.savu ~/.ssh/config.my > ~/.ssh/config
