#!/bin/sh

pushd ../../explorer-app
docker volume rm explorer-app_pgdata
docker-compose -f ./docker-compose.yaml up -d
popd