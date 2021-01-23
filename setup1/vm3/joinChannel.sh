export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_RETAILERSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=trustflow

setGlobalsForPeer0RetailersAssociation() {
    export CORE_PEER_LOCALMSPID="RetailersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

}

setGlobalsForPeer1RetailersAssociation() {
    export CORE_PEER_LOCALMSPID="RetailersAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILERSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

}

fetchChannelBlock() {
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0RetailersAssociation

    # Replace localhost with your orderer's vm IP address
    peer channel fetch 0 ./channel-artifacts/$CHANNEL_NAME.block -o $1:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# fetchChannelBlock

joinChannel() {
    setGlobalsForPeer0RetailersAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer1RetailersAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

}

# joinChannel

updateAnchorPeers() {
    setGlobalsForPeer0RetailersAssociation

    # Replace localhost with your orderer's vm IP address
    peer channel update -o $1:7050 --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

# updateAnchorPeers

fetchChannelBlock $1
joinChannel $1
updateAnchorPeers $1
