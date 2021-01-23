#!/bin/sh

pushd ../explorer-app
./create-org-folder.sh
docker volume rm explorer-app_pgdata
docker-compose -f ./docker-compose.yaml up -d
popd