#!/bin/sh

docker network ls
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker ps -a
docker network ls
docker network rm artifacts_test
docker swarm leave --force

docker swarm init --advertise-addr $1
sleep 2
docker swarm join-token manager > manager_token.txt

sleep 3

docker network create --attachable --driver overlay artifacts_test
