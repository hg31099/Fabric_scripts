#!/bin/sh
docker swarm join --token SWMTKN-1-2zcjfppfofcjrjx317c6n13l7qk414ojfkfd7yrrm23fh2f1u2-ed9z9ht1h1ds40aovjupabuqi 104.41.128.25:2377 --advertise-addr $1
