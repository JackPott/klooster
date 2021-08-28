#!/bin/sh

# Quit on any error
set -e

if [[$(id -u) != 0]]; then
   echo "This script must be run as root"
   exit 1
fi

# Echo on
set -x


cd /tmp
wget https://github.com/poseidon/matchbox/releases/download/v0.9.0/matchbox-v0.9.0-linux-arm.tar.gz
tar zxvf matchbox-v0.9.0-linux-arm.tar.gz
rm -f matchbox-v0.9.0-linux-arm.tar.gz
cd /tmp/matchbox-v0.9.0-linux-arm
pwd

# Remove docs
rm -rf docs
rm -rf examples
rm -f CHANGES.md LICENSE README.md

mkdir -p usr/local/sbin
mkdir -p usr/local/share/matchbox
mkdir -p usr/local/tce.installed

mv ./matchbox usr/local/sbin

mv contrib usr/local/share/matchbox
mv scripts usr/local/share/matchbox

touch usr/local/tce.installed/matchbox

cat > usr/local/tce.installed/matchbox << EOF
#!/bin/sh
CONFDIR=/usr/local/etc

adduser -D matchbox
mkdir -p /var/lib/matchbox/assets
chown matchbox:matchbox /var/lib/matchbox

# Set up for start on boot
echo "/usr/local/sbin/matchbox" > /opt/bootlocal.sh
EOF

chown tc:staff usr/local/tce.installed/matchbox
chmod 755 usr/local/tce.installed/matchbox

cat > usr/local/sbin/start_matchbox << EOF
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
EOF

chmod +x usr/local/sbin/start_matchbox

cd /tmp
rm -f matchbox.tcz
mksquashfs /tmp/matchbox-v0.9.0-linux-arm matchbox.tcz
# rm -rf /tmp/matchbox-v0.9.0-linux-arm

echo "Building package complete"
