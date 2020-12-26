#!/bin/sh

chmod -R 777 .

crypto1(){
    echo "Cryto material creating ..."
    pushd ./vm1/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    docker-compose -f ./docker-compose.yaml up -d
    sleep 5
    ./create-certificate-with-ca.sh
    popd
    echo "crypto material created !"
}
crypto2(){
    echo "Cryto material creating ..."
    pushd ./vm2/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    docker-compose -f ./docker-compose.yaml up -d
    sleep 5
    ./create-certificate-with-ca.sh
    popd
    echo "crypto material created !"
}
crypto3(){
    echo "Cryto material creating ..."
    pushd ./vm3/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    docker-compose -f ./docker-compose.yaml up -d
    sleep 5
    ./create-certificate-with-ca.sh
    popd
    echo "crypto material created !"
}
crypto4(){
    echo "Cryto material creating for orderer..."
    pushd ./vm4/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    docker-compose -f ./docker-compose.yaml up -d
    sleep 5
    ./create-certificate-with-ca.sh
    popd
    echo "crypto material created !"
}


if [ $1 == "1" ]
then
    crypto1
fi
if [ $1 == "2" ]
then
    crypto2
fi
if [ $1 == "3" ]
then
    crypto3
fi
if [ $1 == "4" ]
then
    crypto4
fi

if [ $1 == "artifacts" ]
then
    pushd ../artifacts/channel
    ./create-artifacts.sh
    popd
fi

