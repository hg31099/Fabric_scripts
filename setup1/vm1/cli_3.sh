export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
export CORE_PEER_ADDRESS=peer0.seedsAssociation.example.com:7051
export CHANNEL_NAME="mychannel"
export CC_NAME="fabasset"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"
# export CC_END_POLICY="OR('SeedsAssociationMSP.peer','FarmersAssociationMSP.peer', 'MerchantsAssociationMSP.peer')"
export CC_END_POLICY="OR('SeedsAssociationMSP.peer')"

peer chaincode upgrade -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
-C mychannel -n fabasset \
-v ${VERSION} \
--peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
-c '{"function": "CreateAsset","Args":["w11", "Rice", "Basmati", "hyderabadi", "100","kg", "8", "grain", "true","farmer1", "open to sell"]}'
# --peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
