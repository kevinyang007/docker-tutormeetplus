# install docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo bash -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update
sudo apt-get install -y docker-engine

# install awscli
curl -O https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip install awscli

# configure awscli
aws configure
sudo $(aws ecr get-login)

# install make tool
sudo apt-get install make

# install docker-compose
sudo pip install docker-compose
