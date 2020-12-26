#!/bin/sh

docker exec -it cli bash

export CORE_PEER_LOCALMSPID="SeedsAssociationMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/channel/cryptoconfig/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/cryptoconfig/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp
export CORE_PEER_ADDRESS=peer0.seedsAssociation.example.com:7051
export CHANNEL_NAME="mychannel"
export CC_NAME="fabcar"
export ORDERER_CA=/etc/hyperledger/channel/cryptoconfig/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.comcert.pem
export VERSION="1"

peer lifecycle chaincode commit -o orderer.example.com:7050 --ordererTLSHostnameOverride
orderer.example.com \
--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
--channelID $CHANNEL_NAME --name ${CC_NAME} \
--peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/cryptoconfig/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles
/etc/hyperledger/channel/cryptoconfig/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/cryptoconfig/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
--version ${VERSION} --sequence ${VERSION} --init-required

peer chaincode invoke -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/cryptoconfig/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/cryptoconfig/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles
/etc/hyperledger/channel/cryptoconfig/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
--isInit -c '{"Args":[]}'

peer chaincode invoke -o orderer.example.com:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile /etc/hyperledger/channel/cryptoconfig/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.comcert.pem \
-C mychannel -n fabcar \
--peerAddresses peer0.seedsAssociation.example.com:7051 --tlsRootCertFiles /etc/hyperledger/channel/cryptoconfig/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.farmersAssociation.example.com:9051 --tlsRootCertFiles /etc/hyperledger/channel/cryptoconfig/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt \
--peerAddresses peer0.merchantsAssociation.example.com:11051 --tlsRootCertFiles
/etc/hyperledger/channel/cryptoconfig/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt \
-c '{"function": "createCar","Args":["ps1", "Potato", "seeds", "organic", "Farmer1"]}'

peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["ps1"]}'