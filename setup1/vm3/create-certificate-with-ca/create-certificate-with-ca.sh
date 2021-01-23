createcertificatesForRetailersAssociation() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.retailersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-retailersAssociation-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-retailersAssociation-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-retailersAssociation-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-retailersAssociation-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.retailersAssociation.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.retailersAssociation.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.retailersAssociation.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.retailersAssociation.example.com --id.name retailersAssociationadmin --id.secret retailersAssociationadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.retailersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/msp --csr.hosts peer0.retailersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.retailersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer0.retailersAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/tlsca/tlsca.retailersAssociation.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer0.retailersAssociation.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/ca/ca.retailersAssociation.example.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.retailersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/msp --csr.hosts peer1.retailersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.retailersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer1.retailersAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/peers/peer1.retailersAssociation.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/users/User1@retailersAssociation.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.retailersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/users/User1@retailersAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://retailersAssociationadmin:retailersAssociationadminpw@localhost:10054 --caname ca.retailersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/retailersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/retailersAssociation.example.com/users/Admin@retailersAssociation.example.com/msp/config.yaml

}

createcertificatesForRetailersAssociation

