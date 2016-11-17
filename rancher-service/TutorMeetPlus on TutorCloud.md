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
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo bash -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update
sudo apt-get install -y docker-engine
sudo groupadd docker
sudo usermod -aG docker $USER


sudo -s
curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

```

