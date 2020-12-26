
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME


# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for SeedsAssociationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./SeedsAssociationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg SeedsAssociationMSP

echo "#######    Generating anchor peer update for FarmersAssociationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./FarmersAssociationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg FarmersAssociationMSP

echo "#######    Generating anchor peer update for MerchantsAssociationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./MerchantsAssociationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg MerchantsAssociationMSP