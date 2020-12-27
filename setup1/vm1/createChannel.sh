export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SEEDSASSOCIATION_CA=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForPeer0SeedsAssociation(){
    export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SEEDSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1SeedsAssociation(){
    export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SEEDSASSOCIATION_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}
# echo $1:7050
createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0SeedsAssociation
    
    # Replace localhost with your orderer's vm IP address
    peer channel create -o $1:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./../../artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# createChannel

joinChannel(){
    setGlobalsForPeer0SeedsAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1SeedsAssociation
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

# joinChannel

updateAnchorPeers(){
    setGlobalsForPeer0SeedsAssociation
    # Replace localhost with your orderer's vm IP address
    peer channel update -o $1:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

# updateAnchorPeers

createChannel $1
sleep 4
joinChannel
sleep 4
updateAnchorPeers $1
