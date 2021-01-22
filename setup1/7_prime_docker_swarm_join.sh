#!/bin/sh
docker swarm join --token SWMTKN-1-2w0rnv2b9qaye6vkhk5wiztqcxmbmak9f3ijnn95xhuo7y64vt-c06vc5n3rovljuh3r3etyu380 104.41.128.25:2377 --advertise-addr $1
