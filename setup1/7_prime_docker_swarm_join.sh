#!/bin/sh

docker swarm join --token SWMTKN-1-12xtesyy3h4fq4uwewjje6v0souul0pyt3ifbd6ck24jlinhny-djl3a0v2hqay0a0f96jjpvf97 168.62.175.188:2377 --advertise-addr $1
