#!/bin/sh

chmod -R 777 .

docker1(){
    echo "Docker spinning up 1 ..."
    pushd ./vm1
    docker-compose -f ./docker-compose.yaml up -d
    popd
    echo "Docker for vm1 is up"
}
docker2(){
    echo "Docker spinning up 2 ..."
    pushd ./vm2
    docker-compose -f ./docker-compose.yaml up -d
    popd
    echo "Docker for vm2 is up"
}
docker3(){
    echo "Docker spinning up 3 ..."
    pushd ./vm3
    docker-compose -f ./docker-compose.yaml up -d
    popd
    echo "Docker for vm3 is up"
}
docker4(){
    echo "Docker spinning up 4 ..."
    pushd ./vm4
    docker-compose -f ./docker-compose.yaml up -d
    popd
    echo "Docker for vm4 is up"
}


if [ $1 == "1" ]
then
    docker1
fi
if [ $1 == "2" ]
then
    docker2
fi
if [ $1 == "3" ]
then
    docker3
fi
if [ $1 == "4" ]
then
    docker4
fi


