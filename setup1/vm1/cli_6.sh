# export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
export CORE_PEER_LOCALMSPID="MerchantsAssociationMSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
# export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/users/Admin@merchantsAssociation.example.com/msp
# export CORE_PEER_ADDRESS=peer0.seedsAssociation.example.com:7051
export CORE_PEER_ADDRESS=peer0.merchantsAssociation.example.com:9051
export CHANNEL_NAME="mychannel"
export CC_NAME="fabasset"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"
export CC_END_POLICY="OR('SeedsAssociationMSP.peer','FarmersAssociationMSP.peer', 'MerchantsAssociationMSP.peer')"
export ASSET_PROPERTIES=$(echo -n "{\"object_type\":\"asset_properties\",\"asset_id\":\"r1\",\"owner\":\"farmer1\",\"quantity\":\"100\",\"unit\":\"kg\",\"quality\":\"5\",\"salt\":\"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3\"}" | base64 | tr -d \\n)
export ASSET_PRICE=$(echo -n "{\"object_type\":\"asset_price\",\"asset_id\":\"r1\",\"owner\":\"farmer1\",\"price\":1400,\"salt\":\"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3\"}" | base64 | tr -d \\n)

# peer chaincode invoke -o orderer.example.com:7050 \
# --ordererTLSHostnameOverride orderer.example.com \
# --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
# -C $CHANNEL_NAME -n ${CC_NAME} \
# --peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
# --isInit -c '{"Args":[]}'

sleep 3

peer chaincode invoke -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
-c '{"function": "AgreeToBuy","Args":["r1"]}' --transient "{\"asset_price\":\"$ASSET_PRICE\"}"
# -c '{"function": "ChangePublicDescription","Args":["r1", "Asset Sold"]}' #--transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
# --peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
# -c '{"function": "TransferAsset","Args":["r1","SeedsAssociationMSP"]}' --transient "{\"asset_price\":\"$ASSET_PRICE\", \"asset_properties\":\"$ASSET_PROPERTIES\"}"


# --peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
# -c '{"function": "createAsset","Args":["r2", "Rice", "Basmati", "hyderabadi", "grain", "true","farmer1", "open to sell"]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"



sleep 3

# peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryAsset","Args":["r1"]}'