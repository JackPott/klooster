#!/bin/sh

if [ "$1" = "DAEMON" ]; then
    # is this necessary? Add other signals at will (TTIN TTOU INT STOP TSTP)
    trap '' INT
    cd /tmp
    shift
    ### daemonized section ######
    /usr/local/sbin/matchbox -address 0.0.0.0:8080
    #### end of daemonized section ####
    exit 0
fi

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin
umask 022
# You can add nice and ionice before nohup but they might not be installed
nohup setsid $0 DAEMON $* 2>/var/log/matchbox.err >/var/log/matchbox.log &