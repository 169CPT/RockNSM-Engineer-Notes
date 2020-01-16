# Setup a pFsense

**1. Assign Interfaces**

| LAN4 | LAN3 | LAN2 | LAN1 | COM |
| --- | --- | --- | --- | --- |
| em3 | em2 | em1 | em0 | local |

* Select 1 - Assign interface
  * LAN Side: em1 172.16.50.1
  * WAN Side: em0 10.0.50.1
  * y - to proceed

* Set interfaces IP addresses
  * 1 - WAN interfaces
  * Y - DHCP
  * N - DHCPv6
  * Blank for "none"
  * Y - http webconfig protocol

* Set interfaces IP addresses
  * 2 - LAN interface
    * 172.16.50.1/24
  * <enter> for none
  * <enter> for none - disable ipv6
  * Y - enable DHCP
  * 172.16.50.100 - range start
  * 172.16.50.254 - range end
  * Y - http webconfig protocol

**Finish the Wizard**
In order to access the router, complete the following process:
1. Set your lab machine to static ip  172.16.50.10
2. Plug into the LAN interface (LAN2 on the front of the pfsense) and then browse to 172.16.50.1
3. Complete first login to web GUI (default creds admin/pfsense)

Wizard > Pfsense setup > General Information
set hostname sg50-pFsense
localdomain == local.LAN
primary dns - edge router - 192.168.2.1
uncheck block private networks ad loopback address - uncheck block bogon networks
LAN ip address - 172.16.50.1
Subnet mask - 24
set and document the new admin password
log back in
dashboard overview
top right [+] and add
Services status
Traffic graphs
Firewall > rules
Secure out of the box! Default deny behavior

Firewall > rules > WAN > add
pass.proto=all, source=any, dest=any

firewall > NAT > outbound: disbale radio button

firewall > NAT > LAN > add
pass.proto=all, source=any, dest=any

Now disbale NAT firewall > NAT > outbound: disable radio button

**Configure additional Interfaces**

Assign
interface > assignments
add em2 (OPT1)
add em3 (OPT2)
`save`

Enable
click interface name in list e.g. OPT1
enable interface
ipv4 config type - none
ipv6 config type - none
`save`
Check for double gateway issue
system > routing
make sure there is not more than one gateway entry
