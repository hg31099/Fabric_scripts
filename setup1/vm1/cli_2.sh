export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
export CORE_PEER_ADDRESS=peer0.seedsAssociation.example.com:7051
export CHANNEL_NAME="mychannel"
export CC_NAME="fabcar"
export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export VERSION="1"


peer chaincode invoke -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
--isInit -c '{"Args":[]}'

sleep 3

peer chaincode invoke -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
-C mychannel -n fabcar \
--peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles /etc/hyperledger/channel/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
-c '{"function": "createCar","Args":["ps1", "Potato", "seeds", "organic", "Farmer1"]}'

sleep 3

peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["ps1"]}'