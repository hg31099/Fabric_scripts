export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SEEDSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
export PEER0_FARMERSASSOCIATION_CA=${PWD}/../vm2/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export PEER0_MERCHANTSASSOCIATION_CA=${PWD}/../vm3/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/


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

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./../../artifacts/src/github.com/fabasset/go"
CC_NAME="fabasset"



queryCommitted() {
    setGlobalsForPeer0SeedsAssociation
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}


docker exec -i cli bash < ./cli_1.sh
sleep 3
queryCommitted
sleep 3
docker exec -i cli bash < ./cli_2.sh