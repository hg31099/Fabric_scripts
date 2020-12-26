#!/bin/sh

chmod -R 777 .

crypto1(){
    echo "Cryto material deleting ..."
    pushd ./vm1/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    popd
    echo "crypto material deleted !"
}
crypto2(){
    echo "Cryto material deleting ..."
    pushd ./vm2/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    popd
    echo "crypto material deleted !"
}
crypto3(){
    echo "Cryto material deleting ..."
    pushd ./vm3/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    popd
    echo "crypto material deleted !"
}
crypto4(){
    echo "Cryto material deleting ..."
    pushd ./vm4/create-certificate-with-ca
    rm -rf ../crypto-config/*
    docker-compose -f ./docker-compose.yaml down
    popd
    echo "crypto material deleted !"
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

