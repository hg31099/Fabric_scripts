#!/bin/sh

docker swarm join --token SWMTKN-1-3wajoxct0g6fbntxl8gtumg3e18hyccck4cdgu0lipkbpkd4vv-4uzyf7lbghiaj0nqt99gzsl37 168.62.175.188:2377 --advertise-addr $1
