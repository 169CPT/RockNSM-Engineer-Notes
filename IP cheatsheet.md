# IP Cheatsheet
`ip addr`
`ip a show dev "interface"`
`ip a add "ip address/24" dev "interface"`
`ip a del "ip address/24" dev "interface"`
`ip link`
`ip link show dev "Interface"`
`ip -s link`
`ip link set dev "interface" up`
`ip link set dev "interface" down`
`ip link set dev "interface" promisc on`
`ip route`
`ip neigh`
`ip neigh show dev "interface"`

## Manual Network Settings
config files for each network interface:
`ll /etc/sysconfig/network-scripts`

### USE DHCP
edit the config file for desire interface:
`sudo nano "interface"`
set: `BOOTPROTO=DHCP`
remove: ADDR/PREFIX/GATEWAY info (if any)
verify: restart networking and test

### USE STATIC
edit the config file for desire interface:
`sudo nano "interface"`

set: BOOTPROTO=none
set: IPADDR="ip address"
set: PREFIX=24
set: GATEWAY="gw address"
set: DNS1="dns ip"
set: DNS2="secondary"
verify: restart networking and test

### DISABLE ipv6
sysctl.conf

edit the config file to disbale all IPv6 Interfaces
`sudo nano /etc/sysctl.conf`

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```
load changes from /etc/sysctl.conf file `sudo sysctl -p`

hosts file
edit the host file to remove the ipv6 entry `::1`
`sudo nano /etc/hosts`
