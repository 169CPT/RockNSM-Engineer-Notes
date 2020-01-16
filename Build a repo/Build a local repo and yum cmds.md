# Local Repo
## yum commands
```
yum --help
yum install
yum search
yum update
yum provides
yum makecache fast
yum clean all
yum history
yum history undo "number" #removes packages and dependencies
yum repolist
```
## yum configuration
`cd /etc/yum.repos.d/`  #add sources list for updating and downloading new packages
`sudo nano /etc/yum.conf`
`yum-config-manager --disable "repo name"`
`yum-config-manager --enable "repo name"`

The option in the yum.conf file that breaks the disa stig policy is below
`repo_gpgcheck=1`
The option should be set to 0 if you want to pull metadata from it

## identifing the pieces of a yum dot repo file
```
[repo]
name=repo_name
baseurl=repo_url
enabled=1
gpgcheck=0
```
First line must be unique and is the name of the repo that yum will use

`Name` is the name that will be displayed to the user when listing repo
`baseurl` is where the repository is located. This can use http, file, or ftp protocols


## Download repos
`sudo yum repolist`
`sudo reposync -l --repoid=local-base --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-elasticsearch-7.x --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-epel --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-extras --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-rocknsm-2.5 --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-updates --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-virtualbox --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`
`sudo reposync -l --repoid=local-zerotier --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata`

#### Our paste the following in CLI (/srv/repos)
```
sudo reposync -l --repoid=local-base --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-elasticsearch-7.x --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-epel --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-extras --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-rocknsm-2.5 --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-updates --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-virtualbox --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata;
sudo reposync -l --repoid=local-zerotier --download_path=/srv/repos/ --newest-only --downloadcomps  --download-metadata
```



 ### other options
 `yumdownloader suricata`

 repotrack -a ARCH -p "path to rpm packages" "whatever packages"
 * example: `repotrack -a x86_64 -p /var/www/repos/packages suricata zeek`

 `createrepo /repo/"repo name"`


 ### Create repo
 `sudo yum install createrepo`

 `sudo yum install nginx`

 `ls /srv/repos/local-base/comps.xml`
`createrepo -g comps.xml local-base/`

note:relative path to comps.xml; creates the sql database;
if no comps.xml provided, then remove “-g comps.xml”
do this for all the repos (as shown below in small font)
should see various databases (e.g. sqlite.bz2, xml.gz, etc.)

```
ls /srv/repos/local-base/repodata
cd /srv/repos
ls local-base
sudo createrepo -g comps.xml local-base/
ls local-elasticsearch-7.x
ls local-elasticsearch-7.x/7.5.1/
sudo createrepo local-elasticsearch-7.x
ls local-epel
sudo createrepo -g comps.xml local-epel
ls local-extras
ls local-extras/Packages
sudo createrepo local-extras
ls local-rocknsm-2.5
sudo createrepo local-rocknsm-2.5
ls localstuff
sudo createrepo localstuff
ls local-updates
ls local-updates/Packages
sudo createrepo local-updates
ls local-virtualbox
sudo createrepo local-virtualbox
ls local-WANdisco-git
sudo createrepo local-WANdisco-git
ls local-zerotier
sudo createrepo local-zerotier
```

#### Become root user
`sudo -s` OR `sudo -i`

 #### Create a conf file / redirector
 redirects from port 8008 to local directories
 `sudo nano  /etc/nginx/conf.d/repo.conf `
```
server {
  listen 8008;                             # which port to bind to; default for satellite repos
  location / {
    root /srv/repos;                       # root directory starts here
    autoindex on;                          # use internal indexer from nginx
    index index.html index.htm;            # multiple index files that can be served up
  }
  error_page 500 502 503 504 /50.x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
    }
  }
  ```

* restart nginx
`systemctl restart nginx`
* verify port 8008 is listening - can access locally using curl
`ss -lnt`
* should see html listing of repos
`curl localhost:8008`
*  allow access from other machines
`sudo firewall-cmd --add-port=8008/tcp --permanent`
`sudo firewall-cmd --reload`
* test from remote sensor (e.g. sensor) - failed to connect - denied from SELinux
`curl 192.168.2.86:8008`
not labeled as web file (currently either home or system file)

`cd /srv/`
* repos is unconfined object - tagged as var item, should be http context - need change context
`ls -Z`
* change context recursively
`chcon -R -u system_u -t httpd_sys_content_t repos`
* verify change in context
`ls -Z`
* Restart nginx
`systemctl restart nginx`
`ss -lnt`
* test from remote sensor (e.g. sensor) - now works
`curl 192.168.2.86:8008`

#### 2 steps for troubleshooting, not production environment, e.g. test SELK instead of FSF
`systemctl stop firewalld`
See if firewall issue
`setenforce 0`
With firewall still off, see if SELinux has context
`setenforce 1`
turn back on
`systemctl start firewalld`
turn back on
`getenforce`
verify that back in enforcing mode (1), not permissive mode (0)
