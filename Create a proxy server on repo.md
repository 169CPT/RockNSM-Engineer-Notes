# Creating a proxy on repo server

Create a proxy.conf file
`sudo nano /etc/nginx/conf.d/proxy.conf`

Add the following to the proxy.conf:
```
server {
  listen 80;                                   # default port
  server_name repo repo.local.lan repo
  proxy_max_temp_file_size 0;                  # default limit is 1GB for nginx; set to unlimited
  location / {
    proxy_set_header X-Real_IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_pass http://127.0.0.1:8008;
  }
}
```
