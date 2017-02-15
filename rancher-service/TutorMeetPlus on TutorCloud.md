# TutorMeetPlus on TutorCloud

| Location |      | Public /Internal IP | Service/Port | Hostname |      |      |
| -------- | ---- | ------------------- | ------------ | -------- | ---- | ---- |
| TW       |      |                     |              |          |      |      |
| HK       |      |                     |              |          |      |      |
| HK       |      |                     |              |          |      |      |
|          |      |                     |              |          |      |      |



# Server node Bootstrap

### Install Docker Engine on Ubuntu@14.x

```shell
#!/bin/sh
sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates && \
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list

## Rancher 1.3.x support 1.12.x (docker-engine=1.12.6-0~ubuntu-trusty)
## apt-cache madison <packageName>
## sudo apt-get install -y --force-yes docker-engine=1.12.6-0~ubuntu-trusty && sudo apt-mark hold docker-engine
## sudo apt-mark hold docker-engine
## pdsh -w tmp[1-6].beta.sh "<COMMAND>"
sudo apt-get update && \
sudo apt-get install -y --force-yes --allow-unauthenticated linux-image-extra-$(uname -r) linux-image-extra-virtual docker-engine=1.12.6-0~ubuntu-trusty && \
sudo service docker start && \
sudo usermod -aG docker $USER

sudo -s
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
exit
```



China region

```
curl -sSL https://get.daocloud.io/docker | sh
```



```
## Apply no passwd to sudo
sudo visudo

## /etc/sudoer

```

### Rancher Service

Create DB for HA (RDS)

Setup security group for Nodes IP



Start service (EC2)

```shell
docker run -d --restart=unless-stopped -p 80:8080 -p 9345:9345 --name rancher-server rancher/server \
--db-host rancher-mysql.ctxm00qgfubi.ap-northeast-1.rds.amazonaws.com --db-port 3306 \
--db-user rancher --db-pass password --db-name cattle \
--advertise-address 52.193.72.117 --advertise-http-port 80
```



Start service (Intranet)

```shell
docker run -d --restart=unless-stopped -p 3306:3306 \
	-e MYSQL_DATABASE=cattle -e MYSQL_USER=rancher -e MYSQL_PASSWORD=password \
	--name rancher-mysql \
	mysql


docker run -d --restart=unless-stopped -p 80:8080 -p 9345:9345 \
--name rancher-server rancher/server \
--db-host 172.16.3.122 --db-port 3306 \
--db-user rancher --db-pass password --db-name cattle \
--advertise-address 172.16.3.123 --advertise-http-port 80
	#152.101.38.99
```



Create Volumes

`kms-record`, `kms-sdpfile`, `material`, `redis-data`





### Apply Gluster Server

```shell
# sudo apt-get install python-software-properties software-properties-common 
sudo add-apt-repository ppa:gluster/glusterfs-3.8 && sudo apt-get update

## In China
echo 'deb http://91.189.95.83/gluster/glusterfs-3.8/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/gluster-glusterfs-3_8-trusty.list

## install server
sudo apt-get install -y glusterfs-server

## insatll client
sudo apt-get install -y glusterfs-client
## sudo apt-get update && sudo apt-get upgrade -y glusterfs-client

# Probe slave server
sudo gluster peer probe 172.16.3.122

# Gluster create volume
sudo gluster volume create rancher-volume replica 2 transport tcp 172.16.21.228:/gluster-storage 172.16.9.17:/gluster-storage force

sudo gluster volume reset rancher-volume replica 2 \
172.16.21.228:/gluster-storage \
172.16.3.122:/gluster-storage \
172.16.9.17:/gluster-storage \
172.16.9.16:/gluster-storage \
force

sudo gluster volume add-brick <ip:/gluster-storage>

sudo gluster volume rancher-volume start

sudo mkdir /mnt/tingyao

sudo mount -t glusterfs 172.16.21.228:/rancher-volume /mnt/tingyao

## /etc/fstab
## SG node
172.16.9.16:/rancher-volume /mnt/rancher-volume glusterfs _netdev,rw,acl 0 0
## HK node
172.16.3.122:/rancher-volume /mnt/rancher-volume glusterfs _netdev,rw,acl 0 0
## CH1, CH3
172.16.7.238, 172.16.7.161

## test mount
mount -a

##
## Update fstab
pdsh -w tmp[2-6].beta.sh "sudo mkdir -p /mnt/rancher-volume"
pdsh -w tmp[2-6].beta.sh "echo \"172.16.7.163:/rancher-volume /mnt/rancher-volume glusterfs _netdev,rw,acl 0 0\" | sudo tee -a /etc/fstab"
```



> If peer rejected
>
> On the rejected peer:
>
> 1. Stop glusterd
> 2. In /var/lib/glusterd, delete everything except glusterd.info (the UUID file)
> 3. Start glusterd
> 4. Probe one of the good peers
> 5. Restart glusterd, check 'gluster peer status'
> 6. You may need to restart glusterd another time or two, keep checking peer status.



```sh
sudo service glusterfs-server stop
cd /var/lib/glusterd
ls -q | grep -v glusterd.info | xargs sudo rm -rf
sudo service glusterfs-server start

## /var/lib/glusterd/peers/<UUID>
## change state to 3 to force reset connection
```


### Setup docker registry cache

```shell
echo "DOCKER_OPTS=\"$DOCKER_OPTS --registry-mirror=https://docker-proxy.tutormeet.plus\"" | sudo tee -a /etc/default/docker
```



For RancherOS

```shell
sudo ros config set rancher.docker.registry_mirror https://docker-proxy.tutormeet.plus
```



### Proxy (WebSocket)

```nginx
http {
	server {
        listen 9090;

        set $upstream_endpoint http://172.16.7.53:9090;
        location / {
            # switch off logging
            access_log off;

            # redirect all HTTP traffic to localhost:3000
            proxy_pass $upstream_endpoint;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            # WebSocket support (nginx 1.4)
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
  
  	server {
        listen 9091;

        set $upstream_endpoint http://172.16.7.53:9091;
        location / {
            # switch off logging
            access_log off;

            # redirect all HTTP traffic to localhost:3000
            proxy_pass $upstream_endpoint;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            # WebSocket support (nginx 1.4)
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
  
	server {
        listen 9093;

        set $upstream_endpoint http://172.16.7.53:9093;
        location / {
            # switch off logging
            access_log off;

            # redirect all HTTP traffic to localhost:3000
            proxy_pass $upstream_endpoint;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            # WebSocket support (nginx 1.4)
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
}
```