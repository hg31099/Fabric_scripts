export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_RETAILERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt
export PEER1_RETAILERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"


export CHANNEL_NAME=trustflow

setGlobalsForPeer0RetailersAssociation() {
    export CORE_PEER_LOCALMSPID="RetailersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

}

setGlobalsForPeer1RetailersAssociation() {
    export CORE_PEER_LOCALMSPID="RetailersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_RETAILERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

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
    setGlobalsForPeer0RetailersAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.retailersAssociation ===================== "
}
# packageChaincodepeer0

installChaincodepeer0() {
    setGlobalsForPeer0RetailersAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.retailersAssociation ===================== "

}

# installChaincodepeer0

packageChaincodepeer1() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer1RetailersAssociation
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer1.retailersAssociation ===================== "
    
}
# packageChaincodepeer1


installChaincodepeer1() {

    setGlobalsForPeer1RetailersAssociation
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.retailersAssociation ===================== "
}

# installChaincodepeer1

queryInstalled() {
    setGlobalsForPeer0RetailersAssociation
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.retailersAssociation on channel ===================== "

    setGlobalsForPeer1RetailersAssociation
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer1.retailersAssociation on channel ===================== "
}

# queryInstalled

approveForMyRetailersAssociation() {
    setGlobalsForPeer0RetailersAssociation

    peer lifecycle chaincode approveformyorg -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION} --signature-policy ${CC_END_POLICY}

    echo "===================== chaincode approved from org 3 ===================== "
}
# queryInstalled
# approveForMyRetailersAssociation

checkCommitReadyness() {

    setGlobalsForPeer0RetailersAssociation
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_RETAILERSASSOCIATION_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --signature-policy ${CC_END_POLICY} --output json --init-required
    echo "===================== checking commit readyness from org 3 ===================== "
}

# checkCommitReadyness


presetup $1
packageChaincodepeer0 $1
installChaincodepeer0 $1

packageChaincodepeer1 $1
installChaincodepeer1 $1

queryInstalled $1
approveForMyRetailersAssociation $1
checkCommitReadyness $1