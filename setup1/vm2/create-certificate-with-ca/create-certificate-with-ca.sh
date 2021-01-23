createCertificateForWholesalersAssociation() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/wholesalersAssociation.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.wholesalersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesalersAssociation-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesalersAssociation-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesalersAssociation-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesalersAssociation-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.wholesalersAssociation.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.wholesalersAssociation.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.wholesalersAssociation.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.wholesalersAssociation.example.com --id.name wholesalersAssociationadmin --id.secret wholesalersAssociationadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.wholesalersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/msp --csr.hosts peer0.wholesalersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.wholesalersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer0.wholesalersAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/tlsca/tlsca.wholesalersAssociation.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer0.wholesalersAssociation.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/ca/ca.wholesalersAssociation.example.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.wholesalersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/msp --csr.hosts peer1.wholesalersAssociation.example.com --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.wholesalersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls --enrollment.profile tls --csr.hosts peer1.wholesalersAssociation.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/peers/peer1.wholesalersAssociation.example.com/tls/server.key
  # -----------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/wholesalersAssociation.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/User1@wholesalersAssociation.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.wholesalersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/User1@wholesalersAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://wholesalersAssociationadmin:wholesalersAssociationadminpw@localhost:8054 --caname ca.wholesalersAssociation.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp --tls.certfiles ${PWD}/fabric-ca/wholesalersAssociation/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/wholesalersAssociation.example.com/users/Admin@wholesalersAssociation.example.com/msp/config.yaml

}

createCertificateForWholesalersAssociation