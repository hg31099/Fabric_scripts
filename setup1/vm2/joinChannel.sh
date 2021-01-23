export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_WHOLESALERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=trustflow

setGlobalsForPeer0WholesalersAssociation() {
    export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WHOLESALERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1WholesalersAssociation() {
    export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WHOLESALERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}

fetchChannelBlock() {
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0WholesalersAssociation
    # Replace localhost with your orderer's vm IP address
    peer channel fetch 0 ./channel-artifacts/$CHANNEL_NAME.block -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# fetchChannelBlock

joinChannel() {
    setGlobalsForPeer0WholesalersAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer1WholesalersAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

}

# joinChannel

updateAnchorPeers() {
    setGlobalsForPeer0WholesalersAssociation
    # Replace localhost with your orderer's vm IP address
    peer channel update -o $1:7050 --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

# updateAnchorPeers

fetchChannelBlock $1
joinChannel $1
updateAnchorPeers $1
