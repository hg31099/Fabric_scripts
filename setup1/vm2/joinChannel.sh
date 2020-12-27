export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_FARMERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForPeer0FarmersAssociation() {
    export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1FarmersAssociation() {
    export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}

fetchChannelBlock() {
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0FarmersAssociation
    # Replace localhost with your orderer's vm IP address
    peer channel fetch 0 ./channel-artifacts/$CHANNEL_NAME.block -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# fetchChannelBlock

joinChannel() {
    setGlobalsForPeer0FarmersAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer1FarmersAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

}

# joinChannel

updateAnchorPeers() {
    setGlobalsForPeer0FarmersAssociation
    # Replace localhost with your orderer's vm IP address
    peer channel update -o $1:7050 --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

# updateAnchorPeers

fetchChannelBlock $1
joinChannel $1
updateAnchorPeers $1
