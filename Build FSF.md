# How to install FSF on RockNSM

File Scanning Framework (FSF)

`sudo yum install fsf`

`ls /opt/fsf`
* Should see the client and the server

#### Server
`sudo nano /opt/fsf/fsf-server/conf/config.py`
```
‘LOG_PATH’ : ‘/data/fsf/logs’,
‘YARA_PATH’ : ‘/var/lib/yara-rules/rules.yara’,
'PID_PATH' : '/run/fsf/scanner.pid',
‘EXPORT_PATH’ : ‘/data/fsf/files’,        //archives files marked as malicious here
'EXPORT_PATH' : '/data/fsf/files',
'TIMEOUT' : 60,
'MAX_DEPTH' : 10,
'ACTIVE_LOGGING_MODULES' : ['scan_log', 'rockout'],
}
SERVER_CONFIG = { 'IP_ADDRESS' : "172.16.50.100",
                  'PORT' : 5800 }
```

#### Client

`sudo nano /opt/fsf/fsf-client/conf/config.py`

SERVER_CONFIG = {'IP ADDRESS' : ['172.16.50.100',], 'PORT' : 5800 }

#### Create Directories
`cd /data/fsf`
`sudo mkdir {logs,files}`

#### Change ownership of the directories
`sudo chown -R fsf: /data/fsf/`

#### Start the FSF service
`sudo systemctl start fsf`

#### Change from fsf.pid to scanner.pid
`sudo vi /usr/lib/systemd/system/fsf.service`
**PIDFile=/run/fsf/scanner.pid**

`sudo systemctl daemon-reload`
`sudo systemctl stop fsf`
`sudo systemctl start fsf`

#### Port 5800 should be bound
`ss -lnt`

####   Allow port 5800 in firewal
`sudo firewall-cmd --add-port=5800/tcp --permanent`                  l
`sudo firewall-cmd --reload`

####  Test fsf by downloading a sample file and scanning it
`cd ~`
`curl -L -O http://192.168.2.11:8009/Bro-cheatsheet.pdf`
`/opt/fsf/fsf-client/fsf_client.py --full ~/Bro-cheatsheet.pdf`

#### Pre-formatted data ready to be shipped to kafka; filebeat reads & sends it
`less -S /data/fsf/logs/rockout.log`
* {"Scan Time": "2020-01-10 17:21:56.758490", "Filename": "Bro-cheatsheet.pdf", "objects": [{"META_PDF": {"/Producer": "Skia/PDF m71"}, "meta": {"job": "scan-1440f810a1c1
