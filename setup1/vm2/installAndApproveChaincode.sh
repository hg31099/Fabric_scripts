export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_WHOLESALERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt
export PEER1_WHOLESALERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"
export CHANNEL_NAME=trustflow

setGlobalsForPeer0WholesalersAssociation() {
    export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WHOLESALERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1WholesalersAssociation() {
    export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_WHOLESALERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}

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
    setGlobalsForPeer0WholesalersAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.wholesalersAssociation ===================== "
}
# packageChaincodepeer0

installChaincodepeer0() {
    setGlobalsForPeer0WholesalersAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.wholesalersAssociation ===================== "
}
# installChaincodepeer0

packageChaincodepeer1() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer1WholesalersAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer1.wholesalersAssociation ===================== "
}
# packageChaincodepeer1

installChaincodepeer1() {
    setGlobalsForPeer1WholesalersAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.wholesalersAssociation ===================== "
}

# installChaincodepeer1


queryInstalled() {
    setGlobalsForPeer0WholesalersAssociation
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.wholesalersAssociation on channel ===================== "

    setGlobalsForPeer1WholesalersAssociation
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer1.wholesalersAssociation on channel ===================== "
}

# queryInstalled

approveForMyWholesalersAssociation() {
    setGlobalsForPeer0WholesalersAssociation

    # Replace localhost with your orderer's vm IP address
    peer lifecycle chaincode approveformyorg -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION} --signature-policy ${CC_END_POLICY}

    echo "===================== chaincode approved from org 2 ===================== "
}
# queryInstalled
# approveForMyWholesalersAssociation

checkCommitReadyness() {

    setGlobalsForPeer0WholesalersAssociation
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_WHOLESALERSASSOCIATION_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --signature-policy ${CC_END_POLICY} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness


presetup $1
packageChaincodepeer0 $1
installChaincodepeer0 $1
packageChaincodepeer1 $1
installChaincodepeer1 $1
queryInstalled $1
approveForMyWholesalersAssociation $1
checkCommitReadyness $1