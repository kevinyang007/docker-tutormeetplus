# WebRTC NFS mount steps

## Launch server



#### Prefer nfs-kernel-server

Setup NFS server on Ubuntu

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04

```shell
sudo apt-get update && sudo apt-get install nfs-kernel-server
sudo vim /etc/exports
## /home       111.111.111.111(rw,sync,no_root_squash,no_subtree_check)
## /var/nfs    111.111.111.111(rw,sync,no_subtree_check)
## /registry-data *(rw,sync,no_subtree_check)
sudo exportfs -a
sudo service nfs-kernel-server start
```

#### Docker-based daemon (not tested yet)

```shell
docker run -d -p 2049:2049 -v $(pwd)/exports:/etc/exports --name nfs4 joebiellik/nfs4
```



```shell
docker run -d --privileged -p 111:111/udp -p 111:111/tcp -p 2049:2049/udp -p 2049:2049/tcp -v $(pwd)/record:/record -v $(pwd)/exports:/etc/exports --name unfs3 macadmins/unfs3
```



```shell
docker run -d --privileged --name nfs -p 2049:2049/udp -p 2049:2049/tcp -p 111:111/tcp -p 111:111/udp cpuguy83/nfs-server /record
```



## Install NFS common lib for client side

```

sudo apt-get install -y nfs-common && \
sudo mkdir -p /mnt/nfs/record && \
sudo mount -t nfs4 172.16.7.238:/record /mnt/nfs/record
```



### Install Convoy plugin for Docker

https://github.com/rancher/convoy



```shell
wget https://github.com/rancher/convoy/releases/download/v0.5.0/convoy.tar.gz
tar xvf convoy.tar.gz
sudo cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/

sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
```



#### Mount Convoy-NFS folder

```shell
sudo mkdir /mnt/registry-data
sudo mount -t nfs 172.16.9.16:/docker/convoy-nfs/registry-data /mnt/registry-data
```



#### Start convoy daemon

```
sudo convoy daemon --drivers vfs --driver-opts vfs.path=/mnt/registry-data &
```



#### S3 Fuse File system for backup

```shell
sudo s3fs tutormeetplus-convoy-nfs /docker/convoy-nfs -o passwd_file=~/.s3passwd -o nonempty
```

