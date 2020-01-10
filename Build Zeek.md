# Zeek / Bro Installation
```
Bro/Zeek is hosted in the Perched repo along with its dependencies and plugins.
New version - zeek, zeekctl, zeek-core, zeek-plugin-af_packet, zeek-plugin-kafka    //zeek-core & zeek-core are automatically installed dependencies
Old version - bro, broctl, bro-core, bro-plugin-af_packet, bro-plugin-kafka
```
`sudo yum install zeek zeek-plugin-af_packet zeek-plugin-kafka`

#### Baseline Configuration
Location of the config file depends on what RPM you installed from.  The packages maintain by ROCK are located in `/etc/zeek` as where most others place them under `/opt/zeek/etc`

There are a few main config files that need to be set in order for Bro/Zeek to function properly.  Here they are listed along with some of the fields that need to be considered:
#### `networks.cfg`

* Used to tell bro/zeek about the local trusted IP space using CIDR notation
* Has private IP rnages by default

#### `zeekctl.cfg`    ~~`broctl.cfg`~~

# Lower threshold (in percentage of disk space) for space available on the
# disk that holds SpoolDir. If less space is available, "zeekctl cron" starts
# sending out warning emails.  A value of 0 disables this feature.
`MinDiskSpace = 5`
//not changed in this class, will disable disk writing capabilities

# Rotation interval in seconds for log files on manager (or standalone) node.
# A value of 0 disables log rotation.
`LogRotationInterval = 3600`
//not changed in this class, will disable disk writing capabilities

# Site-specific policy script to load. Zeek will look for this in
# $PREFIX/share/zeek/site. A default local.zeek comes preinstalled
# and can be customized as desired.
`SitePolicyScripts = local.zeek`

//Location of the log directory where log files will be archived each rotation interval.
//LogDir = /var/log/zeek
//change from LogDir = /var/log/zeek to LogDir = /data/zeek
`LogDir = /data/zeek`

Add line at the bottom
`lb_custom.InterfacePrefix=af_packet::`



`sudo mkdir /data/zeek`
//create directory referenced above

* Log-dir: The directory bro/zeek writes its log to
* lb_ucstom.InterfacePrefix=af_packet:: Note: This line does not exist by default and needs to be added in order to tell bro/zeek to use af_packet
`node.cfg`

`network.cfg`
```
10.0.50.0/24          Private IP space
172.16.50.0/24       Private IP space
192.168.0.0/16        Private IP space
```

A typical deployment of Bro/Zeek is run on a single sensor.  Bro/Zeek is not multithreaded which means that each Bro/Zeek process needed to be assigned to a single core and the total workload spread out among many cores.  All of the processes used by Bro/Zeek are clustered in what can be thought of as a single-node cluster.  The cluster is controlled using broctl which has an interactive shell mode as well as a list of commands that can be run directly in the command line.  Note: Bro/Zeek can also be clustered across more than one machine.
The Bro/Zeek cluster is configured in the node.cfg

`sudo vi /etc/zeek/node.cfg`
**Commment out lines 8-11**
**Uncomment lines 16-36**

Only need first worker, delete second worker
**[worker-2]**

Add line to manager
pin_cpus=3
//line 23

Rename [worker-1] to [interface-enp2s0]
interface=enp2s0
lb_method=custom
//load balance method
pin_cpus=1,2
env_vars=fanout_id=93
//af packet creates different ring buffers, which are called fanout_id; random number >= `50`
```
If had an extra interface
[interface-enp2s1]
type=worker
host=local
interface=enp2s1
```

The Bro/Zeek cluster is configured in the node.cfg
* Manager - The manager is a Bro/Zeek process that receives log messages and notices from the rest of the processes in the cluster and outputs a single log file for each log type.
* Proxy - The proxy is a Bro/Zeek process that synchronizes the cluster state and improves efficiency of the cluster by having the workers communicate with it rather than directly to each other.
* Worker - The worker is the Bro/Zeek process that does protocol analysis on the network traffic.  The bulk of the work done by the cluster is done by the workers and they typically make up the majority of the Bro/Zeek processes in a cluster.  NOTE: As a general guideline, allocate approximately 1 core for every 250 Mbps of traffic being analyzed.
```
Example:
[manager]
type=manager
host=localhost
pin_cpus=0
```
```
[proxy-1]
type=proxy
host=localhost
```

Edit `local.zeek`
`cd /usr/share/zeek/site`
**Go to the bottom**
* uncomment the last three heartbleed, vlan-logging, mac-logging

* Add scripts by appending the following lines
  * Must create the scripts
#@load scripts/json                    //comment out for now so that we can see the differences
@load scripts/afpacket
@load scripts/kafka

#### af packet script

`sudo mkdir /usr/share/zeek/site/scripts`

Create a file for the script
`sudo nano afpacket.zeek`
**Cut and Paste the following**
`redef AF_Packet::fanout_id = strcmp(getenv(“fanout_id”),””) == 0 ? ) : to_count(getenv(“fanout_id”));`

**Reference**
`https://github.com/rocknsm/rock-scripts/blob/master/plugins/afpacket.bro`

#### Configure Zeek to use Kafka

`sudo nano /usr/share/zeek/site/scripts/kafka.zeek`

**Cut and Paste the following**
```
redef Kafka::topic_name = "zeek-raw";                //zeek-raw can be any name
redef Kafka::json_timestamps = JSON::TS_ISO8601;
redef Kafka::tag_json = F;
redef Kafka::kafka_conf = table(
    [“metadata.broker.list”] = “<172.16.50.100>:9092”);        //list of sensor IDs at port 9092
          # [“metadata.broker.list”] = “<172.16.50.100>:9092, 172.116.2.100:9092”);    //list most reliable sensors, others will auto-populate
```

# Enable bro logging to kafka for all logs
```
event bro_init() &priority=-5
{
  for (stream_id in Log::active_streams)
  {
    if (|Kafka::logs_to_send| == 0 || stream_id in Kafka::logs_to_send)
    {
        local filter: Log::Filter = [
          $name = fmt("kafka-%s", stream_id),
          $writer = Log::WRITER_KAFKAWRITER,
          $config = table(["stream_id"] = fmt("%s", stream_id))
        ];

        Log::add_filter(stream_id, filter);
    }
  }
}
```
#### Configure Zeek to use json

`sudo nano /usr/share/zeek/site/scripts/json.zeek`

**Cut and Paste the following**

```
redef LogAscii::use_json = T;
redef LogAscii::json_timestamps = JSON::TS_ISO8601;
```
**Reference**
https://gist.github.com/dcode/97039239c74a1c1e420c

**Now run `zeekctl check`**
//see if you have any errors

**Deploy Zeek**
`zeekctl deploy`
//run only after you have no errors

`zeekctl status`
//check the status of zeek

`zeekctl stop`
//stops zeek

`zeekctl cleanup all`
//cleans up the nodes and then run `zeekctl check` if no errors, run `zeekctl deploy`
