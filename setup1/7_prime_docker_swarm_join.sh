#!/bin/sh
docker swarm join --token SWMTKN-1-5xi0ctdw0nm6lpku2qkjrnv8juqjkq25krrn9jd9qjseh4me8h-58wgekwph341uzftij33hv9rg 104.41.128.25:2377 --advertise-addr $1
