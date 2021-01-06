#!/bin/sh

pushd ./vm1/api-2.0/config/
# ./generate-ccp.sh
popd 


pushd ./vm1/api-2.0
echo $PWD
docker-compose -f ./docker-compose.yml down
sleep 5
docker-compose -f ./docker-compose.yml up -d
popd

pushd ./vm1/create-certificate-with-ca
docker-compose -f ./docker-compose.yaml down
docker-compose -f ./docker-compose.yaml up -d
popd