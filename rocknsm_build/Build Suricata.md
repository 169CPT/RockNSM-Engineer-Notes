# Install SURICATA

`sudo yum install suricata`

#### Configure Suricata
`sudo -s`
`nano -c /etc/suricata/suricata.yaml`

#### Disable Logs
```
56     - /data/suricata
76     - enabled: no
291    - unified2-alert:  #verify that disabled
297    - http-log:
307    - tls-log:
320    - tls-store:
354    - pcap-log:
388    - alert-debug:
403    - stats:
404    - enabled: no
```
#### Default Log Dir
`sudo suricata-update`
`sudo suricata-update list-enabled-sources`
rules are located in `/var/lib/suricata/rules`

#### Edit Sniffing Interface
`sudo nano /etc/sysconfig/suricata`
`OPTIONS="--af-packet=enp2s0 --user suricata "`  #(promisc mode interface)

#### Override Suricata yaml with our changes
`sudo nano /etc/suricata/<my-overides.yaml>`
`include:default-log-dir:/data/suricata`  #you can do this instead of modifying the original file


#### CPU affinity settings
```
cpu-affinity:
    - management-cpu-set:
        cpu: [ 0 ]  # include only these CPUs in affinity settings
    - receive-cpu-set:
        cpu: [ 0 ]  # include only these CPUs in affinity settings
    - worker-cpu-set:
        cpu: [ "all" ]
        mode: "exclusive"
        # Use explicitely 3 threads and don't compute number by using
        # detect-thread-ratio variable:
        # threads: 3
        prio:
          low: [ 0 ]
          medium: [ "1-2" ]
          high: [ 3 ]
          default: "medium"
    #- verdict-cpu-set:
    #    cpu: [ 0 ]
    #    prio:
    #      default: "high"
```
#### DONT DO
`sudo cat /proc/cpuinfo | egrep -e 'processor|physical id|core id' | xargs -l3`

Processor is that is actually being pinned by Suricata Physical ID identifies the actual physical cpu hardwareCore ID Identificaes each core in CPU as shown below:
processor : 0 physical id : 0 core id : 0 processor : 1 physical id : 0 core id : 1 processor : 2 physical id : 0 core id : 2 processor : 3 physical id : 0 core id : 3 processor : 4 physical id : 0 core id : 0 processor : 5 physical id : 0 core id : 1 processor : 6 physical id : 0 core id : 2 processor : 7 physical id : 0 core id : 3

#### Download Rules
`cd /usr/share/suricata/rules`
`curl -L -O http://192.168.2.11:8009/suricata-5.0/emerging.rules.tar.gz`
`tar -xzf emerging.rules.tar.gz`
`cp /usr/share/suricata/classification.config  /etc/suricata/`
`chown -R suricata: /etc/suricata/classification.config`
`cp /usr/share/suricata/reference.config /etc/suricata/`
`chown -R suricata: /etc/suricata/reference.config`
`suricata-update`
`chown -R suricata: /data/suricata`
`systemctl start suricata`
`systemctl status suricata`

#### Troubleshooting
`journalctl -xeu suricata`

Error opening file(40) - error opening /etc/suricata              # file is located in a different location, so make a copy of the file
```
cp /usr/share/suricata/classification.config /etc/suricata .      # seems like not necessary on mine
cp /usr/share/suricata/reference.confg /etc/suricata .
```
