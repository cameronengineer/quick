# 2024-10-31 16:43:41 by RouterOS 7.10.2
# software id = QTD3-T1DN
#
# model = RB960PGS
# serial number = D5310EE81D19
/interface bridge
add admin-mac=2C:C8:1B:A2:7B:CD auto-mac=no comment="Default bridge" name=\
    default
/interface ethernet
set [ find default-name=sfp1 ] auto-negotiation=no
/interface vlan
add interface=default name=cloudtraffic vlan-id=1
add interface=default name=guest vlan-id=30
add interface=default name=trusted vlan-id=10
add interface=default name=untrusted vlan-id=20
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=default-dhcp ranges=10.31.78.10-10.31.78.254
add name=trusted ranges=10.31.79.10-10.31.79.200
add name=guest ranges=10.31.80.10-10.31.80.200
add name=untrusted ranges=10.31.81.10-10.31.81.200
/ip dhcp-server
add address-pool=default-dhcp interface=default lease-time=10m name=defconf
add address-pool=guest interface=guest lease-time=10m name=guest
add address-pool=trusted interface=trusted lease-time=10m name=trusted
add address-pool=untrusted interface=untrusted lease-time=10m name=untrusted
/interface bridge port
add bridge=default comment=ether2 interface=ether2
add bridge=default comment=ether3 interface=ether3
add bridge=default comment=ether4 interface=ether4
add bridge=default comment=ether5 interface=ether5
add bridge=default comment=sfp1 interface=sfp1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface bridge vlan
add bridge=default tagged=guest vlan-ids=30
add bridge=default tagged=untrusted vlan-ids=20
add bridge=default tagged=trusted vlan-ids=10
/interface list member
add comment=defconf interface=default list=LAN
add comment=defconf interface=ether1 list=WAN
add interface=trusted list=LAN
/ip address
add address=10.31.78.1/24 comment=defconf interface=default network=\
    10.31.78.0
add address=10.31.79.1/24 comment=trusted interface=trusted network=\
    10.31.79.0
add address=10.31.80.1/24 comment=guest interface=guest network=10.31.80.0
add address=10.31.81.1/24 comment=untrusted interface=untrusted network=\
    10.31.81.0
/ip dhcp-client
add comment=defconf interface=ether1
/ip dhcp-server lease
add address=10.31.78.2 client-id=1:2c:c8:1b:8:f2:d4 mac-address=\
    2C:C8:1B:08:F2:D4 server=defconf
add address=10.31.78.51 client-id=\
    ff:66:dd:96:70:0:1:0:1:2b:c7:fb:44:c8:1f:66:dd:96:70 mac-address=\
    C8:1F:66:DD:96:70
add address=10.31.78.52 client-id=\
    ff:42:28:49:98:0:1:0:1:2b:cb:49:2b:44:a8:42:28:49:98 mac-address=\
    44:A8:42:28:49:98 server=defconf
add address=10.31.78.53 client-id=\
    ff:ce:67:c3:5c:0:1:0:1:2c:6f:77:c3:7c:e:ce:67:c3:5c mac-address=\
    7C:0E:CE:67:C3:5C server=defconf
add address=10.31.78.50 mac-address=B6:AB:03:1C:9F:F8 server=defconf
/ip dhcp-server network
add address=10.31.78.0/24 comment=defconf dns-server=10.31.78.1 gateway=\
    10.31.78.1
add address=10.31.79.0/24 comment=trusted dns-server=10.31.79.1 gateway=\
    10.31.79.1 netmask=24
add address=10.31.80.0/24 comment=guest dns-server=10.31.80.1 gateway=\
    10.31.80.1 netmask=24
add address=10.31.81.0/24 comment=untrusted dns-server=10.31.81.1 gateway=\
    10.31.81.1 netmask=24
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=10.31.78.207 comment=colok3s regexp=\
    ".*\\.colo\\.cameronengineer\\.com"
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment=\
    "defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related hw-offload=yes
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/ipv6 address
# duplicate address detected
add from-pool=CC_HOME_WAN interface=default
/ipv6 dhcp-client
add add-default-route=yes interface=ether1 pool-name=CC_HOME_WAN \
    pool-prefix-length=56 request=address,prefix
/ipv6 firewall address-list
add address=::/128 comment="defconf: unspecified address" list=bad_ipv6
add address=::1/128 comment="defconf: lo" list=bad_ipv6
add address=fec0::/10 comment="defconf: site-local" list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped" list=bad_ipv6
add address=::/96 comment="defconf: ipv4 compat" list=bad_ipv6
add address=100::/64 comment="defconf: discard only " list=bad_ipv6
add address=2001:db8::/32 comment="defconf: documentation" list=bad_ipv6
add address=2001:10::/28 comment="defconf: ORCHID" list=bad_ipv6
add address=3ffe::/16 comment="defconf: 6bone" list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=input comment="defconf: accept UDP traceroute" port=\
    33434-33534 protocol=udp
add action=accept chain=input comment=\
    "defconf: accept DHCPv6-Client prefix delegation." dst-port=546 protocol=\
    udp src-address=fe80::/10
add action=accept chain=input comment="defconf: accept IKE" dst-port=500,4500 \
    protocol=udp
add action=accept chain=input comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=input comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=input comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=input comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
add action=accept chain=forward comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop packets with bad src ipv6" src-address-list=bad_ipv6
add action=drop chain=forward comment=\
    "defconf: drop packets with bad dst ipv6" dst-address-list=bad_ipv6
add action=drop chain=forward comment="defconf: rfc4890 drop hop-limit=1" \
    hop-limit=equal:1 protocol=icmpv6
add action=accept chain=forward comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=forward comment="defconf: accept HIP" protocol=139
add action=accept chain=forward comment="defconf: accept IKE" dst-port=\
    500,4500 protocol=udp
add action=accept chain=forward comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=forward comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=forward comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=forward comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
/system clock
set time-zone-name=Australia/Melbourne
/system note
set show-at-login=no
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
