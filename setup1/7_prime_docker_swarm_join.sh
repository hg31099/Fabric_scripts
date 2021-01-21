#!/bin/sh
docker swarm join --token SWMTKN-1-48xmvnpfufrhibk26epi5ezh1mbs5u6y81bs69r5nym2gx40o7-6r4zubhh4c1e1e17h1telwgm9 104.41.128.25:2377 --advertise-addr $1
