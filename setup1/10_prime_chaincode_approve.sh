#!/bin/sh

chmod -R 777 .


chain2(){
    echo "chaincode approve channel 2 ..."
    pushd ./vm2/
    ./installAndApproveChaincode.sh $2
    popd
    echo "Chaincode installed and approved in 2"
    pushd ./vm2/create-certificate-with-ca
    # docker-compose -f ./docker-compose.yaml down
    docker-compose -f ./docker-compose.yaml up -d
    popd
}
chain3(){
    echo "chaincode approve channel 3 ..."
    pushd ./vm3/
    ./installAndApproveChaincode.sh $2
    popd
    echo "Chaincode installed and approved in 3"
    pushd ./vm3/create-certificate-with-ca
    # docker-compose -f ./docker-compose.yaml down
    docker-compose -f ./docker-compose.yaml up -d
    popd
}


if [ $1 == "2" ]
then
    chain2 $1 $2
fi
if [ $1 == "3" ]
then
    chain3 $1 $2
fi


