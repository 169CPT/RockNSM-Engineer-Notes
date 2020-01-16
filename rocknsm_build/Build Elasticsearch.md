# Install Elasticsearch  

`sudo yum install elastciserch`  

**elasticsearch.yml**  
`sudo nano /etc/elasticsearch/elasticsearch.yml`  

**Modify the following lines:**   
```   
Line 17:  cluster.name: team50
Line 23:  node.name: sensor50  
line 27:  node.name: r1
Line 33:  path.data: /data/elasticsearch  
Line 43:  uncomment  
Line 55:  network.host: _local:ipv4_   
Line 59:  uncomment  

`sudo nano /etc/elasticsearch/jvm.options`  
change to 8gbs to min and max  

#### Override  
`sudo mkdir /etc/systemd/system/elasticsearch.serviced`  
`sudo nano /etc/systemd/system/elasticsearch.serviced/override.conf`

#### Change ownership
`chown -R elasticsearch: /data/elasticsearch`  

#### Add firewall permissions  
`firewall-cmd --add-port==9200/tcp --permanent`  
`firewall-cmd  --reload`    


#### Start elasticsearch  
`sudo systemctl start elasticsearch`  

**Check to see if elasticsearch is running**
`curl localhost:9200`

**Additional troubleshooting steps**  
`curl localhost:9200/_cat`     
