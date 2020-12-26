#!/bin/sh

chmod -R 777 .


chain2(){
    echo "chaincode approve channel 2 ..."
    pushd ./setup1/vm2/
    ./installAndApproveChaincode.sh $2
    popd
    echo "Chaincode installed and approved in 2"
}
chain3(){
    echo "chaincode approve channel 3 ..."
    pushd ./setup1/vm3/
    ./installAndApproveChaincode.sh $2
    popd
    echo "Chaincode installed and approved in 3"
}


if [ $1 == "2" ]
then
    chain2
fi
if [ $1 == "3" ]
then
    chain3
fi


