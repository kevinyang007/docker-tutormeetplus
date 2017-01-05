# TutorMeetPlus on TutorCloud

| Location |      | Public /Internal IP | Service/Port | Hostname |      |      |
| -------- | ---- | ------------------- | ------------ | -------- | ---- | ---- |
| TW       |      |                     |              |          |      |      |
| HK       |      |                     |              |          |      |      |
| HK       |      |                     |              |          |      |      |
|          |      |                     |              |          |      |      |



# Server node Bootstrap

### Install Docker Engine on Ubuntu14.x

```shell
#!/bin/sh
sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates && \
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update && \
sudo apt-get install -y --allow-unauthenticated linux-image-extra-$(uname -r) linux-image-extra-virtual docker-engine && \
sudo service docker start && \
sudo usermod -aG docker $USER

sudo -s
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
exit
```

