# Install Stenographer

`sudo yum install stenographer`

#### Configure Stengrapher
`cd /etc/stenographer/`
`ls`
`sudo nano config`
```
{
  "Threads": [
    { "PacketsDirectory": "/data/steno/packets/"
    , "IndexDirectory": "/data/steno/index/"
    , "MaxDirectoryFiles": 30000
    , "DiskFreePercentage": 10
    }
  ]
  , "StenotypePath": "/usr/bin/stenotype"
  , "Interface": "enp2s0"
  , "Port": 1234
  , "Host": "127.0.0.1"
  , "Flags": []
  , "CertPath": "/etc/stenographer/certs"
}
```
#### Certificates
`sudo stenokeys.sh stenographer stenographer`
`ll /data/`
`sudo chown -R stenographer: /data/steno`
`sudo systemctl start stenographer`
`sudo systemctl status stenographer`

#### Stop Stenographer
`systemctl stop stenographer`

## Ethtool
A tool for modifying a network card. We want to turn of any kind of offloading or other things the card would normally do because we wan to allow our tools to capture them in a raw format, by allowing the NIC to interact with the packets before we see them is not best practice.

`ethtool -K "interface" tso off gro off lro off gso off rx off tx off sg off rxvlan off txvlan off`
`ethtool -N "interface" rx-flow-hash udp4 sdfn`
`ethtool -N "interface" rx-flow-hash udp6 sdfn`
`ethtool -C "interface" adaptive-rx off`
`ethtool -C "interface" rx-usecs 1000`
`ethtool -G "interface" rx 4096`

**nic-card-mod.sh**
```
#!/bin/bash
for var in $@
do
    echo "turning off offloading on $var”
    ethtool -K $var tso off gro off lro off gso off rx off tx off sg off rxvlan off txvlan off
    ethtool -N $var rx-flow-hash udp4 sdfn
    ethtool -N $var rx-flow-hash udp6 sdfn
    ethtool -C $var adaptive-rx off
    ethtool -C $var rx-usecs 1000
    ethtool -G $var rx 4096
done
exit 0
```
`sudo systemctl status stenographer`
Loaded: loaded (...; disabled; vendor preset: disabled); [vendor preset tells if enabled after install]
stenographer (pcap) uses lots of system resources, so instructor does not enable if not needed

`cat /usr/lib/systemd/system/stenographer.service`

`ls /etc/systemd/system`
overrides usr service files; global override; recommend not to put services here
