createCertificateForFarmersAssociation() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/farmersAssociation.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.farmersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmersAssociation-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmersAssociation-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmersAssociation-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmersAssociation-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.farmersAssociation.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.farmersAssociation.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.farmersAssociation.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.farmersAssociation.example.com --id.name farmersAssociationadmin --id.secret farmersAssociationadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/farmersAssociation.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.farmersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/msp --csr.hosts peer0.farmersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.farmersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer0.farmersAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/tlsca/tlsca.farmersAssociation.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer0.farmersAssociation.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/ca/ca.farmersAssociation.example.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.farmersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/msp --csr.hosts peer1.farmersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.farmersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer1.farmersAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/peers/peer1.farmersAssociation.example.com/tls/server.key
  # -----------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/farmersAssociation.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/farmersAssociation.example.com/users/User1@farmersAssociation.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.farmersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/users/User1@farmersAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://farmersAssociationadmin:farmersAssociationadminpw@localhost:8054 --caname ca.farmersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmersAssociation.example.com/users/Admin@farmersAssociation.example.com/msp/config.yaml

}

createCertificateForFarmersAssociation