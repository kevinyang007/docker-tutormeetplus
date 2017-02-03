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
sudo apt-get install -y glusterfs-server

# Gluster create volume
sudo gluster volume create rancher-volume replica 2 transport tcp 172.16.21.228:/gluster-storage 172.16.9.17:/gluster-storage force

sudo gluster volume reset rancher-volume replica 2 \
172.16.21.228:/gluster-storage \
172.16.3.122:/gluster-storage \
172.16.9.17:/gluster-storage \
172.16.9.16:/gluster-storage \
force

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