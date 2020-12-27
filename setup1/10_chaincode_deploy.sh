#!/bin/sh

pushd ./vm1/
./deployChaincode.sh $1
popd