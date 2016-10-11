# WebRTC NFS mount steps

## Launch server

```shell
docker run -d --privileged -p 111:111/udp -p 111:111/tcp -p 2049:2049/udp -p 2049:2049/tcp -v $(pwd)/record:/record -v $(pwd)/exports:/etc/exports --name unfs3 macadmins/unfs3
```





## Install NFS common lib for client side

```

sudo apt-get install -y nfs-common && \
sudo mkdir -p /mnt/record && \
sudo mount -t nfs 172.16.7.238:/record /mnt/record

```