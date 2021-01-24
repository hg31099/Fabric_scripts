export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
export CORE_PEER_ADDRESS=peer0.farmersAssociation.example.com:7051
export CHANNEL_NAME="trustflow"
export CC_NAME="fabasset"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"

# export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
# export CORE_PEER_LOCALMSPID="WholesalersAssociationMSP"
# # export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
# # export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
# export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt
# export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp
# # export CORE_PEER_ADDRESS=peer0.farmersAssociation.example.com:7051
# export CORE_PEER_ADDRESS=peer0.wholesalersAssociation.example.com:9051
# export CHANNEL_NAME="trustflow"
# export CC_NAME="fabasset"
# export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
# export VERSION="1"
# export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer', 'RetailersAssociationMSP.peer')"


peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "QueryAssetHistory","Args":["r1"]}'