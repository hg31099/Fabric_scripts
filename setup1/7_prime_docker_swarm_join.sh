#!/bin/sh

docker swarm join --token SWMTKN-1-0arzlspscdofwqwu90gxj4rlvmflufdvenpd3r15xxsm4lcu4x-9cw0e3ek2zjtqcdplye4u9svr 168.62.175.188:2377 --advertise-addr $1
