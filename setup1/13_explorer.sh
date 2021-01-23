#!/bin/sh

pushd ../explorer-app
# ./create-org-folder.sh
sleep 3
docker-compose -f ./docker-compose.yaml down
# sleep 2
docker volume rm explorer-app_pgdata
docker volume rm explorer-app_walletstore

sleep 2
docker-compose -f ./docker-compose.yaml up -d
popd