#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    local PP1=$(one_line_pem $6)
    sed -e "s/\${SORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${PEERPEM1}#$PP1#" \
        -e "s#\${P0PORT1}#$7#" \
        -e "s/\${BORG}/$8/" \
        -e "s/\${IP}/$9/" \
        ./ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${SORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${BORG}/$8/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


echo "" > connection-farmersAssociation.json
echo "" > connection-merchantsAssociation.json
echo "" > connection-seedsAssociation.json

SORG="seedsAssociation"
BORG="SeedsAssociation"
P0PORT=7051
CAPORT=7054
IP=104.41.128.25
P0PORT1=8051
PEERPEM=../../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/tlscacerts/tls-localhost-7054-ca-seedsAssociation-example-com.pem
PEERPEM1=../../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/tlscacerts/tls-localhost-7054-ca-seedsAssociation-example-com.pem
CAPEM=../../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/tlscacerts/ca.crt
echo "$(json_ccp $SORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1 $BORG $IP)" > connection-seedsAssociation.json

SORG="farmersAssociation"
BORG="FarmersAssociation"
P0PORT=9051
IP=52.170.250.32
CAPORT=8054
P0PORT1=10051
PEERPEM=../../../vm2/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/tlscacerts/tls-localhost-8054-ca-farmersAssociation-example-com.pem
PEERPEM1=../../../vm2/crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/tlscacerts/tls-localhost-8054-ca-farmersAssociation-example-com.pem
CAPEM=../../../vm2/crypto-config/peerOrganizations/farmersAssociation.example.com/msp/tlscacerts/ca.crt
echo "$(json_ccp $SORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1 $BORG $IP)" > connection-farmersAssociation.json

SORG="merchantsAssociation"
BORG="MerchantsAssociation"
P0PORT=11051
CAPORT=10054
IP=20.83.163.11
P0PORT1=12051
PEERPEM=../../../vm3/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/tlscacerts/tls-localhost-10054-ca-merchantsAssociation-example-com.pem
PEERPEM1=../../../vm3/crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/tlscacerts/tls-localhost-10054-ca-merchantsAssociation-example-com.pem
CAPEM=../../../vm3/crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/tlscacerts/ca.crt
echo "$(json_ccp $SORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1 $BORG $IP)" > connection-merchantsAssociation.json


