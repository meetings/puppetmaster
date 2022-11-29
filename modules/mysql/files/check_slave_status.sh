#!/bin/sh
mysql -e 'SHOW SLAVE STATUS\G' | awk '/Slave.*Running/{if ($2 != "Yes") {print}}'
