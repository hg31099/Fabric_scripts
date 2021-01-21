const { Gateway, Wallets, TxEventHandler, GatewayOptions, DefaultEventHandlerStrategies, TxEventHandlerFactory } = require('fabric-network');
const fs = require('fs');
const path = require("path")
const log4js = require('log4js');
const logger = log4js.getLogger('BasicNetwork');
const util = require('util')

// const createTransactionEventHandler = require('./MyTransactionEventHandler.ts')

const helper = require('./helper')

// const createTransactionEventHandler = (transactionId, network) => {
//     /* Your implementation here */
//     const mspId = network.getGateway().getIdentity().mspId;
//     const myOrgPeers = network.getChannel().getEndorsers(mspId);
//     return new MyTransactionEventHandler(transactionId, network, myOrgPeers);
// }

const invokeTransaction = async (channelName, chaincodeName, fcn, args, username, org_name, transientData, peers) => {
    try {               
        logger.debug(util.format('\n============ invoke transaction on channel %s ============\n', channelName));

        // load the network configuration
        // const ccpPath =path.resolve(__dirname, '..', 'config', 'connection-seedsAssociation.json');
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
            // transaction: {
            //     strategy: createTransactionEventhandler()
            // }
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

        // let result
        // let message;
        // switch (fcn) {
        //     case "CreateInvoice":
        //         result = await contract.submitTransaction(fcn, args[0]);
        //         // obj = JSON.stringify(JSON.parse(args[0]))
        //         // console.log(JSON.parse(args[0]))
        //         message = `Successfully added the Invoice Data`
        //         break;
        //     case "UpdateInvoice":
        //         if (org_name == "SeedsAssociation") {
        //             return { message: "Only Organization 2 is allowed to add transactions" }
        //         } else {
        //             result = await contract.submitTransaction(fcn, args[0], args[1], args[2]);
        //             // obj = JSON.stringify(JSON.parse(args[0]))
        //             // console.log(JSON.parse(args[0]))
        //             message = `Successfully updated the Invoice Data`
        //             break;
        //         }


        //     // case ""

        //     default:
        //         return utils.getResponsePayload("Please send correct chaincode function name", null, false)
        //         break;
        // }
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
            transientDataBuffer[key] = Buffer.from(JSON.stringify(assetData.asset_properties))

            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .setEndorsingPeers(peers)
                        .submit(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
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
            transientDataBuffer[key1] = Buffer.from(JSON.stringify(assetData.asset_properties))
            transientDataBuffer[key2] = Buffer.from(JSON.stringify(assetData.asset_price))
            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .submit(args[0], args[1])
            message = `Successfully executed the function`
        } else if (fcn == "AgreeToSell" || fcn == "AgreeToBuy") {
            console.log(`Transient data is : ${transientData}`)
            let tstring=JSON.stringify(transientData)
            let assetData = JSON.parse(tstring)
            console.log(`Transient data change is : ${tstring}`)
            console.log(`asset data is : ${JSON.stringify(assetData)}`)
            let key = Object.keys(assetData)[0]
            const transientDataBuffer = {}
            transientDataBuffer[key] = Buffer.from(JSON.stringify(assetData.asset_price))
            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .submit(args[0])
            message = `Successfully executed the function`
        }else if (fcn == "VerifyAssetProperties"){
            console.log(`Transient data is : ${transientData}`)
            let tstring=JSON.stringify(transientData)
            let assetData = JSON.parse(tstring)
            console.log(`Transient data change is : ${tstring}`)
            console.log(`asset data is : ${JSON.stringify(assetData)}`)
            let key = Object.keys(assetData)[0]
            const transientDataBuffer = {}
            transientDataBuffer[key] = Buffer.from(JSON.stringify(assetData.asset_properties))
            result = await contract.createTransaction(fcn)
                        .setTransient(transientDataBuffer)
                        .submit(args[0])
            message = `Successfully executed the function`
        } else if (fcn == "ChangePublicDescription")
        {
            result = await contract.createTransaction(fcn)
                        .submit(args[0])
            message = `Successfully executed the function`
        }
        else {
            return `Invocation require either createAsset or changeAssetOwner as function but got ${fcn}`
        }
        await gateway.disconnect();

        // result = JSON.parse(result.toString());

        let response = {
            message: message
            // result
        }

        // let response = {
        //     message: message,
        //     result
        // }

        return response;


    } catch (error) {

        console.log(`Getting error: ${error}`)
        return error.message

    }
}

exports.invokeTransaction = invokeTransaction;