#!/bin/sh

docker swarm join --token SWMTKN-1-0lmf047fmsw3co119bdnluerxp384ivlxnxmv3c1sc0fvmgg77-dbovpdxtsssjumly25tsidmn5 168.62.175.188:2377 --advertise-addr $1
