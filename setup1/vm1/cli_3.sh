export CORE_PEER_LOCALMSPID="FarmersAssociationMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp
export CORE_PEER_ADDRESS=peer0.farmersAssociation.example.com:7051
export CHANNEL_NAME="trustflow"
export CC_NAME="fabasset"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"
export ASSET_PROPERTIES=$(echo -n "{\"object_type\":\"asset_properties\",\"assetID\":\"r1\",\"quantity\":\"100\",\"unit\":\"kg\",\"quality\":\"5\",\"tradeID\":\"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3\"}" | base64 | tr -d \\n)
export CC_END_POLICY="OR('FarmersAssociationMSP.peer','WholesalersAssociationMSP.peer','RetailersAssociationMSP.peer')"
# export CC_END_POLICY="OR('FarmersAssociationMSP.peer')"

peer chaincode upgrade -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
-C trustflow -n fabasset \
-v ${VERSION} \
--peerAddresses peer0.farmersAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
-c '{"function": "ReadAsset","Args":["p1"]}'
# -c '{"function": "CreateAsset","Args":["r1", "Rice", "Basmati", "hyderabadi", "grain", "true", "open to sell","FarmerCli1"]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
# --peerAddresses peer0.wholesalersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt \
# --peerAddresses peer0.retailersAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt \
