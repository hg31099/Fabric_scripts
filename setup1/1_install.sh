sudo apt-get update
sudo apt-get upgarde
sudo apt-get install curl

sudo apt-get install nodejs

sudo apt-get install npm

sudo apt-get install python

sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"


sudo apt-get update

apt-cache policy docker-ce

sudo apt install docker-ce

sudo groupadd docker

sudo usermod -aG docker $USER

newgrp docker


sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version

sudo apt-get update
sudo apt-get upgrade

docker run hello-world