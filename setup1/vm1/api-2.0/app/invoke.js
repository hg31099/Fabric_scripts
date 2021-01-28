const { Gateway, Wallets, TxEventHandler, GatewayOptions, DefaultEventHandlerStrategies, TxEventHandlerFactory } = require('fabric-network');
const fs = require('fs');
const path = require("path")
const log4js = require('log4js');
const logger = log4js.getLogger('BasicNetwork');
const util = require('util')

// const createTransactionEventHandler = require('./MyTransactionEventHandler.ts')

const helper = require('./helper')
var uniqueID = (function() {
  var id = 1; // This is the private persistent value
  // The outer function returns a nested function that has access
  // to the persistent value.  It is this nested function we're storing
  // in the variable uniqueID above.
  return function() { return id++; };  // Return and increment
})(); // Invoke the outer function after defining it.
var counter
const invokeTransaction = async (channelName, chaincodeName, fcn, args, username, org_name, transientData, peers) => {
    try {               
        logger.debug(util.format('\n============ invoke transaction on channel %s ============\n', channelName));

        // load the network configuration
        // const ccpPath =path.resolve(__dirname, '..', 'config', 'connection-farmersAssociation.json');
        // const ccpJSON = fs.readFileSync(ccpPath, 'utf8')
        const ccp = await helper.getCCP(org_name) //JSON.parse(ccpJSON);

        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(org_name) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        let identity = await wallet.get(username);
        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, org_name, true)
            identity = await wallet.get(username);
            console.log('Run the registerUser.js application before retrying');
            return;
        }


        const connectOptions = {
            wallet, identity: username, discovery: { enabled: true, asLocalhost: false },
            eventHandlerOptions: {
                commitTimeout: 100,
                // strategy : DefaultEventHandlerStrategies.MSPID_SCOPE_ALLFORTX
                // strategy: DefaultEventHandlerStrategies.NETWORK_SCOPE_ALLFORTX
            }

        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, connectOptions);

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const mspId = network.getGateway().getIdentity().mspId;
        const myOrgPeers = network.getChannel().getEndorsers(mspId);
        console.log(`MSPID : ${mspId}`)
        console.log(`Endorser : ${myOrgPeers}`)
        

        const contract = network.getContract(chaincodeName);

    
        let result
        let message;
        if (fcn == "CreateAsset") {
          
            console.log(`Transient data is : ${transientData}`)
            let tstring=JSON.stringify(transientData)
            let assetData = JSON.parse(tstring)
            console.log(`Transient data change is : ${tstring}`)
            console.log(`asset data is : ${JSON.stringify(assetData)}`)
            let key = Object.keys(assetData)[0]
            const transientDataBuffer = {}
            // transientDataBuffer[key] = Buffer.from(JSON.stringify(assetData.asset_properties))
            counter=uniqueID()
            console.log(JSON.stringify(assetData.asset_properties) )
            const orderedTransient = Object.keys(assetData.asset_properties).sort().reduce(
                (obj, key) => { 
                  obj[key] = assetData.asset_properties[key]; 
                  return obj;
                }, 
                {}
              );
              console.log(JSON.stringify(orderedTransient));
              transientDataBuffer[key] = Buffer.from(JSON.stringify(orderedTransient))

            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .setEndorsingPeers(peers)
                        .submit(args[0], args[1], args[2], args[3], args[4], args[5], args[6], username,counter.toString())
            // counter=counter+1

          
            message = `Successfully added the asset asset with key ${args[0]}`

        } else if ( fcn == "TransferAsset") {
            console.log(`Transient data is : ${transientData}`)
            let tstring=JSON.stringify(transientData)
            let assetData = JSON.parse(tstring)
            console.log(`Transient data change is : ${tstring}`)
            console.log(`asset data is : ${JSON.stringify(assetData)}`)
            let key1 = Object.keys(assetData)[0]
            let key2 = Object.keys(assetData)[1]
            const transientDataBuffer = {}
            console.log(JSON.stringify(assetData.asset_properties) )
            const orderedTransient1 = Object.keys(assetData.asset_properties).sort().reduce(
                (obj, key) => { 
                  obj[key] = assetData.asset_properties[key]; 
                  return obj;
                }, 
                {}
              );
              console.log(JSON.stringify(orderedTransient1));
              transientDataBuffer[key1] = Buffer.from(JSON.stringify(orderedTransient1))
            console.log(JSON.stringify(assetData.asset_price) )
            const orderedTransient2 = Object.keys(assetData.asset_price).sort().reduce(
                (obj, key) => { 
                  obj[key] = assetData.asset_price[key]; 
                  return obj;
                }, 
                {}
              );
              console.log(JSON.stringify(orderedTransient2));
              transientDataBuffer[key2] = Buffer.from(JSON.stringify(orderedTransient2))
            // transientDataBuffer[key1] = Buffer.from(JSON.stringify(assetData.asset_properties))
            // transientDataBuffer[key2] = Buffer.from(JSON.stringify(assetData.asset_price))
            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .setEndorsingPeers(peers)
                        .submit(args[0], args[1],args[2],username,args[3],args[4])
            message = `Successfully executed the function`
        } else if (fcn == "AgreeToSell" || fcn == "AgreeToBuy") {
            console.log(`Transient data is : ${transientData}`)
            let tstring=JSON.stringify(transientData)
            let assetData = JSON.parse(tstring)
            console.log(`Transient data change is : ${tstring}`)
            console.log(`asset data is : ${JSON.stringify(assetData)}`)
            let key = Object.keys(assetData)[0]
            const transientDataBuffer = {}
            // transientDataBuffer[key] = Buffer.from(JSON.stringify(assetData.asset_price))
            console.log(JSON.stringify(assetData.asset_price) )
            const orderedTransient = Object.keys(assetData.asset_price).sort().reduce(
                (obj, key) => { 
                  obj[key] = assetData.asset_price[key]; 
                  return obj;
                }, 
                {}
              );
              console.log(JSON.stringify(orderedTransient));
              transientDataBuffer[key] = Buffer.from(JSON.stringify(orderedTransient))
            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .setEndorsingPeers(peers)
                        .submit(args[0],username)
            message = `Successfully executed the function`
        }else if (fcn == "VerifyAssetProperties"){
            console.log(`Transient data is : ${transientData}`)
            let tstring=JSON.stringify(transientData)
            let assetData = JSON.parse(tstring)
            console.log(`Transient data change is : ${tstring}`)
            console.log(`asset data is : ${JSON.stringify(assetData)}`)
            let key = Object.keys(assetData)[0]
            const transientDataBuffer = {}

            console.log(JSON.stringify(assetData.asset_properties) )
            const orderedTransient = Object.keys(assetData.asset_properties).sort().reduce(
                (obj, key) => { 
                  obj[key] = assetData.asset_properties[key]; 
                  return obj;
                }, 
                {}
              );
              console.log(JSON.stringify(orderedTransient));
              transientDataBuffer[key] = Buffer.from(JSON.stringify(orderedTransient))
            // transientDataBuffer[key] = Buffer.from(JSON.stringify(assetData.asset_properties))
            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .submit(args[0])
            message = `Successfully executed the function`
        } else if (fcn == "ChangePublicDescription")
        {
            result = await contract.createTransaction(fcn)
                        .setEndorsingPeers(peers)
                        .submit(args[0],args[1],username)
            message = `Successfully executed the function`
        }
        else {
            return `Invocation require either createAsset or changeAssetOwner as function but got ${fcn}`
        }
        await gateway.disconnect();

        // result = JSON.parse(result.toString());

        let response = {
            message: message,
            result: result
         
        }
        return response;

        

    } catch (error) {

        console.log(`Getting error: ${error}`)
        return error.message

    }
}

exports.invokeTransaction = invokeTransaction;