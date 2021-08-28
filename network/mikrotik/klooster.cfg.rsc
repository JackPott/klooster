:delay 30s
/interface bridge
add name=bridge disabled=no auto-mac=yes protocol-mode=rstp comment=initial
/interface wireless security-profiles
add name="wpa2psk" mode=dynamic-keys authentication-types=wpa2-psk \
    wpa2-pre-shared-key="klooster net" management-protection=disabled \
    supplicant-identity=MikroTik
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=\
    20/40mhz-XX country=no_country_set disabled=no distance=indoors \
    frequency=auto frequency-mode=manual-txpower mode=ap-bridge \
    ssid=klooster station-roaming=enabled wireless-protocol=802.11 \
    security-profile=wpa2psk
/interface list
add comment=initial name=WAN
add comment=initial na
/interface bridge port
add bridge=bridge comment=initial interface=ether1
add bridge=bridge comment=initial interface=wlan1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=initial interface=bridge list=LAN
add comment=initial interface=ether2 list=WAN
/ip address
add address=10.254.254.254/24 comment=initial interface=bridge network=\
    10.254.254.0
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/ip dhcp-client
add comment="initial" interface=ether2 disabled=no
/ip ssh
set forwarding-enabled=remote
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
