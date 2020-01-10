# Configure a Cisco Switch

`ssh perched@10.0.0.1`
password: `perched1234!@#$`

**Enter Privledge Mode**
`enable`
`perched1234!@#$`
`conf t`
 `do sh run` # shows running config

**Setup DHCP**
`ip dhcp exclude-address 10.0.50.0 10.0.50.1`
`ip dhcp pool student group 50`
`network 10.0.50.0 255.255.255.252`
`dns-server 192.168.2.1`
`exit`

**Setup VLANS**
`vlan 150`
`name TEAM50`
`state active`
`no shut`
`exit`

**Add interfaces**
`interface gigabitethernet 1/0/13`
`switchport`
`switchport access vlan150`
`no shut`
`exit`

`interface vlan150`
`description Team 50`
`ip address 10.0.50.1 255.255.255.252`
`no shut`
`exit`

**Enable a static route**
`ip routing`
`ip route 172.16.50.0 255.255.255.0 10.0.50.2`
