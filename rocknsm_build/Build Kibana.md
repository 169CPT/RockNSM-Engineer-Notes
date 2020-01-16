# Install Kibana  

`sudo yum install kibana`  

**Open fireall**  
`sudo firewall-cmd --add-port=5601/tcp --permanent`
'sudo firewall-cmd --reload'   

**Modify the following file**  

`sudo nano /etc/kibana/kibana.yml`  

Modify the following lines:  
Line 7:  server.host: "172.16.5.100"  
Line 28:  elastcisearch.hosts: ["http://localhost:9200"]  
