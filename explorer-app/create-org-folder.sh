cd organizations/peerOrganizations
mkdir farmersAssociation.example.com
mkdir wholesalersAssociation.example.com
mkdir retailersAssociation.example.com
cd ../..
cd ../setup1/vm1/crypto-config/peerOrganizations
cp -r farmersAssociation.example.com/* ../../../../explorer-app/organizations/peerOrganizations
cd ../../../vm2/crypto-config/peerOrganizations
cp -r wholesalersAssociation.example.com/* ../../../../explorer-app/organizations/peerOrganizations
cd ../../../vm3/crypto-config/peerOrganizations
cp -r retailersAssociation.example.com/* ../../../../explorer-app/organizations/peerOrganizations

cd organizations/ordererOrganizations
cd ../../../vm4/crypto-config/ordererOrganizations
cp -r example.com/* ../../../../explorer-app/organizations/ordererOrganizations