wget https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz

tar -xzvf go1.15.5.linux-amd64.tar.gz

sudo mv go/ /usr/local

echo 'export GOPATH=/usr/local/go' >> ~/.bashrc 

echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc 

source ~/.bashrc

go version

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -

sudo apt-get install -y nodejs

curl -V
npm -v
docker version
docker-compose version
go version
python -V
node -v