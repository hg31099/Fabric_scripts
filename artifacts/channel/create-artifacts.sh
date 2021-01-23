
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm genesis.block trustflow.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "trustflow"
CHANNEL_NAME="trustflow"

echo $CHANNEL_NAME


# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./trustflow.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for FarmersAssociationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./FarmersAssociationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg FarmersAssociationMSP

echo "#######    Generating anchor peer update for WholesalersAssociationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./WholesalersAssociationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg WholesalersAssociationMSP

echo "#######    Generating anchor peer update for RetailersAssociationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./RetailersAssociationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg RetailersAssociationMSP