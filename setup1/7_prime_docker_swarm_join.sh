#!/bin/sh

docker swarm join --token SWMTKN-1-4wc5nfzff67misnnx9aoqwyxklgomcn5lskucfl5tg7vwsss81-16mbuwf9lhntxp14dyc8zeed5 168.62.175.188:2377 --advertise-addr $1
