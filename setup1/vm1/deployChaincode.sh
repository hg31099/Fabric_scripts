export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SEEDSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
export PEER0_FARMERSASSOCIATION_CA=${PWD}/../vm2/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export PEER0_MERCHANTSASSOCIATION_CA=${PWD}/../vm3/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/
export CC_END_POLICY="OR('SeedsAssociationMSP.peer','FarmersAssociationMSP.peer','MerchantsAssociationMSP.peer')"

export CHANNEL_NAME=mychannel

setGlobalsForPeer0SeedsAssociation() {
    export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SEEDSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1SeedsAssociation() {
    export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SEEDSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051

}

# setGlobalsForPeer0FarmersAssociation() {
#     export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMERSASSOCIATION_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:9051

# }

# setGlobalsForPeer1FarmersAssociation() {
#     export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMERSASSOCIATION_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:10051

# }

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./../../artifacts/src/github.com/fabasset/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./../../artifacts/src/github.com/fabasset/go"
CC_NAME="fabasset"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.seedsAssociation ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.seedsAssociation ===================== "

}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.seedsAssociation on channel ===================== "
}

# queryInstalled

approveForMySeedsAssociation() {
    setGlobalsForPeer0SeedsAssociation
    # set -x
    # Replace localhost with your orderer's vm IP address
    peer lifecycle chaincode approveformyorg -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} --signature-policy ${CC_END_POLICY} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

# queryInstalled
# approveForMySeedsAssociation

checkCommitReadyness() {
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --signature-policy ${CC_END_POLICY} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SEEDSASSOCIATION_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_MERCHANTSASSOCIATION_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0SeedsAssociation
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA \
         --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_MERCHANTSASSOCIATION_CA \
        --isInit -c '{"Args":[]}'

}

 # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SEEDSASSOCIATION_CA \

# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0SeedsAssociation

    ## Create Asset
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SEEDSASSOCIATION_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA   \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_MERCHANTSASSOCIATION_CA \
        -c '{"function": "createCar","Args":["ps1", "Potato", "seeds", "organic", "Farmer1"]}'

    ## Init ledger
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SEEDSASSOCIATION_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA \
    #     -c '{"function": "initLedger","Args":[]}'

}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0SeedsAssociation

    # Query Asset by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["ps1"]}'
 
}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode

presetup $1
packageChaincode $1
installChaincode $1
queryInstalled $1
approveForMySeedsAssociation $1
# chaincodeQuery

# docker exec -i cli bash < ./cli_1.sh
# sleep 3
# queryCommitted
# sleep 3
# docker exec -i cli bash < ./cli_2.sh