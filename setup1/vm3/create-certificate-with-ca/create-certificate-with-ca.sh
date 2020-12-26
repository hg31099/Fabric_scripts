createcertificatesForMerchantsAssociation() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.merchantsAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-merchantsAssociation-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-merchantsAssociation-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-merchantsAssociation-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-merchantsAssociation-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.merchantsAssociation.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.merchantsAssociation.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.merchantsAssociation.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.merchantsAssociation.example.com --id.name merchantsAssociationadmin --id.secret merchantsAssociationadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.merchantsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/msp --csr.hosts peer0.merchantsAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.merchantsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer0.merchantsAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/tlsca/tlsca.merchantsAssociation.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer0.merchantsAssociation.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/ca/ca.merchantsAssociation.example.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.merchantsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/msp --csr.hosts peer1.merchantsAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.merchantsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer1.merchantsAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/peers/peer1.merchantsAssociation.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/users/User1@merchantsAssociation.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.merchantsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/users/User1@merchantsAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/merchantsAssociation.example.com/users/Admin@merchantsAssociation.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://merchantsAssociationadmin:merchantsAssociationadminpw@localhost:10054 --caname ca.merchantsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/users/Admin@merchantsAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/merchantsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/merchantsAssociation.example.com/users/Admin@merchantsAssociation.example.com/msp/config.yaml

}

createcertificatesForMerchantsAssociation

