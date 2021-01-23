export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
export CORE_PEER_ADDRESS=peer0.farmersAssociation.example.com:7051
export CHANNEL_NAME="trustflow"
export CC_NAME="fabasset"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"
# export CC_END_POLICY="AND('FarmersAssociationMSP.peer')"

peer lifecycle chaincode commit -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
--channelID $CHANNEL_NAME --name ${CC_NAME} \
--peerAddresses peer0.farmersAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.retailersAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.wholesalersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt \
--version ${VERSION} --sequence ${VERSION} --init-required --signature-policy ${CC_END_POLICY}
