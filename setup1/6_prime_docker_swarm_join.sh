#!/bin/sh

docker swarm join --token SWMTKN-1-5txvhkz8mgmamn69na919i8hj1te5ak8ie4j9xkyxnmcvei71f-3yd0xjznx4udnhu6d3ewqkgfl hostip:2377 --advertise-addr thisMachineIP
