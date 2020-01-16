# Install Logstash  

`sudo yum install logstash`  

**To change the heap size**  
`cd /etc/logstash/`    
`sudo nano jvm.options`  

**To change the path where to store data**  
`cd /etc/logstash/`  
`sudo nano logstash.yml` //DONT CHANGE FOR THIS CLASS  

**Pipeline configurations**  
`cd /etc/logstash/conf.d/`  

**Create the following:**  
`sudo nano 100-input-zeek.conf`   

**Troubleshooting**  
tail -f /var/log/logstash/logstash-plan  

`/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/"file" -t`    

**Modifying kibana to index logstash input**
index mapping  
zeek index mapping see `zeek_index_mappings`  
*cut and pasta into dev ops and hit the play button   
