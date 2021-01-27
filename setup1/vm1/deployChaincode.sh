export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_FARMERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export PEER0_WHOLESALERSASSOCIATION_CA=${PWD}/../vm2/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt
export PEER0_RETAILERSASSOCIATION_CA=${PWD}/../vm3/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt

export PEER1_FARMERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/ca.crt
export PEER1_WHOLESALERSASSOCIATION_CA=${PWD}/../vm2/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/ca.crt
export PEER1_RETAILERSASSOCIATION_CA=${PWD}/../vm3/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"
export ASSET_PROPERTIES=$(echo -n "{\"object_type\":\"asset_properties\",\"assetID\":\"r1\",\"quantity\":\"100\",\"unit\":\"kg\",\"quality\":\"5\",\"tradeID\":\"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3\"}" | base64 | tr -d \\n)


export CHANNEL_NAME=trustflow

setGlobalsForPeer0FarmersAssociation() {
    export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1FarmersAssociation() {
    export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_FARMERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051

}

# setGlobalsForPeer0WholesalersAssociation() {
#     export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WHOLESALERSASSOCIATION_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:9051

# }

# setGlobalsForPeer1WholesalersAssociation() {
#     export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WHOLESALERSASSOCIATION_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
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

CHANNEL_NAME="trustflow"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./../../artifacts/src/github.com/fabasset/go"
CC_NAME="fabasset"

packageChaincodepeer0() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0FarmersAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.farmersAssociation ===================== "
}
# packageChaincode peer0

installChaincodepeer0() {
    setGlobalsForPeer0FarmersAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.farmersAssociation ===================== "

}
# installChaincode peer0

packageChaincodepeer1() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer1FarmersAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer1.farmersAssociation ===================== "
}
# packageChaincode peer1

installChaincodepeer1() {
    setGlobalsForPeer1FarmersAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.farmersAssociation ===================== "

}
# installChaincode peer1


queryInstalledpeer0() {
    setGlobalsForPeer0FarmersAssociation
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.farmersAssociation on channel ===================== "
}
# queryInstalled peer0

queryInstalledpeer1() {
    setGlobalsForPeer1FarmersAssociation
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer1.farmersAssociation on channel ===================== "
}

# queryInstalled peer1

approveForMyFarmersAssociation() {
    setGlobalsForPeer0FarmersAssociation
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
# approveForMyFarmersAssociation

checkCommitReadyness() {
    setGlobalsForPeer0FarmersAssociation
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --signature-policy ${CC_END_POLICY} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0FarmersAssociation
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_WHOLESALERSASSOCIATION_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_RETAILERSASSOCIATION_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0FarmersAssociation
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0FarmersAssociation
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_WHOLESALERSASSOCIATION_CA \
         --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_RETAILERSASSOCIATION_CA \
        --isInit -c '{"Args":[]}'

}

 # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA \

# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0FarmersAssociation

    ## Create Asset
    peer chaincode invoke -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    -C $CHANNEL_NAME -n ${CC_NAME} \
    --peerAddresses peer0.farmersAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
    -c '{"function": "CreateAsset","Args":["r1", "Rice", "Basmati", "hyderabadi", "grain", "true", "open to sell"]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"

    ## Init ledger
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_FARMERSASSOCIATION_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_WHOLESALERSASSOCIATION_CA \
    #     -c '{"function": "initLedger","Args":[]}'

}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0FarmersAssociation

    # Query Asset by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "ReadAsset","Args":["r1"]}'
 
}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode

presetup $1
packageChaincodepeer0 $1
installChaincodepeer0 $1
packageChaincodepeer1 $1
installChaincodepeer1 $1

queryInstalledpeer0 $1
queryInstalledpeer1 $1
approveForMyFarmersAssociation $1
chaincodeQuery

# docker exec -i cli bash < ./cli_1.sh
# sleep 3
# queryCommitted
# sleep 3
# docker exec -i cli bash < ./cli_2.sh