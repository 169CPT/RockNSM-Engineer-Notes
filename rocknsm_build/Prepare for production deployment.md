`systemctl stop logstash suricata stenographer fsf kafka zookeeper elasticsearch`  

`rm -rf /var/lib/zookeeper/version-2/`  

`rm -rf /data/kafka/*`  

`rm -f /data/fsf/logs/rockout.log`  

`rm -f /data/suricata/eve.json`  

`rm -f /data/steno/thread0/`

`rm -f /data/steno/thread0/packets/*`    

`rm -f /data/steno/thread0/index/*`   

`systemctl start elasticsearch`  

`systemctl start logstash suricata stenographer fsf kafka zookeeper`  
