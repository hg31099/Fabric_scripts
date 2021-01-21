git config --global core.autocrlf false 

git config --global core.longpaths true

mkdir HyperLedger

cd HyperLedger/

curl -sSL http://bit.ly/2ysbOFE | bash -s

echo 'export PATH=$PATH:/home/ubuntu/HyperLedger/fabric-samples/bin' >> ~/.bashrc

cd /etc/docker

touch daemon.json

echo '{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3" 
  }
}' >> daemon.json

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo service docker restart