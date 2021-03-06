# export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
export CORE_PEER_LOCALMSPID="RetailersAssociationMSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
# export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp
# export CORE_PEER_ADDRESS=peer0.farmersAssociation.example.com:7051
export CORE_PEER_ADDRESS=peer0.retailersAssociation.example.com:9051
export CHANNEL_NAME="trustflow"
export CC_NAME="fabasset"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"
export ASSET_PROPERTIES=$(echo -n "{\"object_type\":\"asset_properties\",\"assetID\":\"r1\",\"quantity\":\"100\",\"unit\":\"kg\",\"quality\":\"5\",\"tradeID\":\"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3\"}" | base64 | tr -d \\n)
export ASSET_PRICE=$(echo -n "{\"object_type\":\"asset_price\",\"assetID\":\"r1\",\"price\":1500,\"tradeID\":\"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3\"}" | base64 | tr -d \\n)

# peer chaincode invoke -o orderer.example.com:7050 \
# --ordererTLSHostnameOverride orderer.example.com \
# --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
# -C $CHANNEL_NAME -n ${CC_NAME} \
# --peerAddresses peer0.farmersAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.wholesalersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.retailersAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt \
# --isInit -c '{"Args":[]}'

sleep 3

peer chaincode invoke -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses peer0.retailersAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt \
-c '{"function": "AgreeToBuy","Args":["r1","wholesalerCli1"]}' --transient "{\"asset_price\":\"$ASSET_PRICE\"}"
# -c '{"function": "ChangePublicDescription","Args":["r1", "Asset Sold"]}' #--transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
# --peerAddresses peer0.farmersAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
# -c '{"function": "TransferAsset","Args":["r1","FarmersAssociationMSP"]}' --transient "{\"asset_price\":\"$ASSET_PRICE\", \"asset_properties\":\"$ASSET_PROPERTIES\"}"


# --peerAddresses peer0.farmersAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.retailersAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.wholesalersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt \
# -c '{"function": "createAsset","Args":["r2", "Rice", "Basmati", "hyderabadi", "grain", "true","farmer1", "open to sell"]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"



sleep 3

# peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryAsset","Args":["r1"]}'