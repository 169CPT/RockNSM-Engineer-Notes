# Install Kafka

Kafka contains topics - e.g. fsf, suricata, and zeek topics - can break topics into partitions - can cluster with other students - load balance with PC1, PC2, PC3, PC4, PC5 - kafka is designed to be broken into thousands of partitions - want 5 partitions for FSF topic (one for each PC), but multiply by 5 or 10 to increase the number of partitions - allows you to scale upwards
RAID 0 - often done with kafka - kafka has its own built-in redundancy - with a replication factor of 1, a copy is created (replica) - a replica cannot exist where the same partition exists - zookeeper will ensure that partition1 is on a different machine than replica1 - if not possible, then no replica is used - with 5 nodes, the maximum replication is 4

`sudo yum install zookeeper kafka`

#### //will add multiple parameters when doing multi-node
`sudo vi /etc/zookeeper/zoo.cfg`

#### Zookeeper must run before kafka
`sudo systemctl start zookeeper`
`systemctl status zookeeper`

#### Configure Kafka
`sudo nano /etc/kafka/server.properties`

**Will change `broker.id=0` when we cluster**

**Line 31 - uncomment and add sensor ip**
`listeners=PLAINTEXT://172.16.50.100:9092`

**Line 36 - uncomment and add sensor ip**
`advertised.listeners=PLAINTEXT://172.16.40.100:9092`

**Line 60 - change directory to /data/kafka**
`log.dirs=/data/kafka`

**Line 103 and 107 - Log retention (stores data for 7 days by default)**
`log.retention.hours=###`
`log.retention.bytes=####`

**Line 123 - Update with multi-node (cluster) deployment**
`zookeeper.connect=localhost:2181`

**Check permissions on /data/kafka**
`sudo chown -R kafka: /data/kafka`

**Restart kafka**
`sudo systemctl start kafka`

**Troubleshooting Kafka**
`/usr/share/kafka/bin/kafka-topics.sh --list --bootstrap-server 172.16.50.100:9002`
`/usr/share/kafka/bin/kafka-topics.sh --describe --topic zeek-raw --bootstrap-server 172.16.50.100:9002`
`/usr/share/kafka/bin/kafka-console-consumer.sh --bootstrap-server 172.16.50.100:9002 --topic zeek-raw`
  
