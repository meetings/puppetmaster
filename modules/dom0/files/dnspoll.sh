#!/bin/bash
# dnspoll.sh, 2013-11-21 / Meetin.gs

taste_the_water_in_well() {
    [ "$(dig ${2} +short)" == "${1}" ] || {
        dig ${2}
        exit 1
    }
}

taste_the_water_in_well "176.9.12.105" "meetin.gs"

exit 0
