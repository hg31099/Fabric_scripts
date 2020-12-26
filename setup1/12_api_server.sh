#!/bin/sh

pushd .vm1/api-2.0/config/
echo > connection-seedsAssociation.json
./generate-ccp.sh
popd 
pushd ./vm1/api-2.0/
docker-compose -f ./docker-compose.yaml down
docker-compose -f ./docker-compose.yaml up -d
popd