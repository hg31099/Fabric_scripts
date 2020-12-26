createcertificatesForSeedsAssociation() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.seedsAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-seedsAssociation-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-seedsAssociation-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-seedsAssociation-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-seedsAssociation-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.seedsAssociation.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.seedsAssociation.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.seedsAssociation.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.seedsAssociation.example.com --id.name seedsAssociationadmin --id.secret seedsAssociationadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.seedsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/msp --csr.hosts peer0.seedsAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.seedsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer0.seedsAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/tlsca/tlsca.seedsAssociation.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer0.seedsAssociation.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/ca/ca.seedsAssociation.example.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.seedsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/msp --csr.hosts peer1.seedsAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.seedsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer1.seedsAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/peers/peer1.seedsAssociation.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/users/User1@seedsAssociation.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.seedsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/users/User1@seedsAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://seedsAssociationadmin:seedsAssociationadminpw@localhost:7054 --caname ca.seedsAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/seedsAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/seedsAssociation.example.com/users/Admin@seedsAssociation.example.com/msp/config.yaml

}

createcertificatesForSeedsAssociation
