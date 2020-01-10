# Add DNS Entries
1.  Logon to pfsense: http://172.16.50.1/
note: does not automatically turn on if loses power
2. Navigate to the following:
Services → DNS resolver → add Host Overrides
3. Set the following conditions:
Host: repo
Domain: local.lan
`make up something unique; remember what it is; local.lan not routed to internet`
IP: 192.168.2.253
`repo laptop ip`
Description: Repos on laptop
Save
Apply changes
`verify entry in host overrides`
DNS Query Forwarding
`check the box if you want to be able to “ping repo” and get response from upstream DNS`   
