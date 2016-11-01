# WebRTC NFS mount steps

## Launch server

```shell
docker run -d --privileged -p 111:111/udp -p 111:111/tcp -p 2049:2049/udp -p 2049:2049/tcp -v $(pwd)/record:/record -v $(pwd)/exports:/etc/exports --name unfs3 macadmins/unfs3
```



```shell
docker run -d --privileged --name nfs -p 2049:2049/udp -p 2049:2049/tcp -p 111:111/tcp -p 111:111/udp cpuguy83/nfs-server /record
```



Setup NFS server on Ubuntu

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04



## Install NFS common lib for client side

```

sudo apt-get install -y nfs-common && \
sudo mkdir -p /mnt/nfs/record && \
sudo mount -t nfs4 172.16.7.238:/record /mnt/nfs/record
```
