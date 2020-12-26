#!/bin/sh

pushd ./setup1/vm1/
./deployChaincode.sh $1
popd