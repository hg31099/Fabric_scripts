export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_MERCHANTSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/


export CHANNEL_NAME=mychannel

setGlobalsForPeer0MerchantsAssociation() {
    export CORE_PEER_LOCALMSPID="MerchantsAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MERCHANTSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/merchantsAssociation.example.com/users/Admin@merchantsAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

}

setGlobalsForPeer1MerchantsAssociation() {
    export CORE_PEER_LOCALMSPID="MerchantsAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MERCHANTSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/merchantsAssociation.example.com/users/Admin@merchantsAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

}

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./../../artifacts/src/github.com/fabcar/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./../../artifacts/src/github.com/fabcar/go"
CC_NAME="fabcar"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0MerchantsAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.merchantsAssociation ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0MerchantsAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.merchantsAssociation ===================== "

}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0MerchantsAssociation
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.merchantsAssociation on channel ===================== "
}

# queryInstalled

approveForMyMerchantsAssociation() {
    setGlobalsForPeer0MerchantsAssociation

    peer lifecycle chaincode approveformyorg -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from org 3 ===================== "
}
# queryInstalled
# approveForMyMerchantsAssociation

checkCommitReadyness() {

    setGlobalsForPeer0MerchantsAssociation
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_MERCHANTSASSOCIATION_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 3 ===================== "
}

# checkCommitReadyness


presetup $1
packageChaincode $1
installChaincode $1
queryInstalled $1
approveForMyMerchantsAssociation $1
checkCommitReadyness $1