package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	sc "github.com/hyperledger/fabric-protos-go/peer"
	"github.com/hyperledger/fabric/common/flogging"
	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
)

// SmartContract Define the Smart Contract structure
type SmartContract struct {
}

// Asset :  Define the asset structure, with 4 properties.  Structure tags are used by encoding/json library
type asset struct {
	Item   string `json:"item"`
	Subtype1   string `json:"subtype1"`
	Subtype2   string `json:"subtype2"`
	Quantity   int `json:"quantity"`
	QuantityUnit  string `json:"quantityunit"`
	Type   string `json:"type"`
	Organic   string `json:"organic"`
	Owner   string `json:"owner"`
	CreationTimestamp   time.Time  `json:"creationtimestamp"`
}

type assetPrivateDetails struct {
	Owner string `json:"owner"`
	Price string `json:"price"`
}

// Init ;  Method for initializing smart contract
func (s *SmartContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

var logger = flogging.MustGetLogger("fabasset_cc")

// Invoke :  Method for INVOKING smart contract
func (s *SmartContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	function, args := APIstub.GetFunctionAndParameters()
	logger.Infof("Function name is:  %d", function)
	logger.Infof("Args length is : %d", len(args))

	switch function {
	case "queryAsset":
		return s.queryAsset(APIstub, args)
	case "initLedger":
		return s.initLedger(APIstub)
	case "createAsset":
		return s.createAsset(APIstub, args)
	case "queryAllAssets":
		return s.queryAllAssets(APIstub)
	case "changeAssetOwner":
		return s.changeAssetOwner(APIstub, args)
	case "getHistoryForAsset":
		return s.getHistoryForAsset(APIstub, args)
	case "queryAssetsByOwner":
		return s.queryAssetsByOwner(APIstub, args)
	case "restictedMethod":
		return s.restictedMethod(APIstub, args)
	case "test":
		return s.test(APIstub, args)
	case "createPrivateAsset":
		return s.createPrivateAsset(APIstub, args)
	case "readPrivateAsset":
		return s.readPrivateAsset(APIstub, args)
	case "updatePrivateData":
		return s.updatePrivateData(APIstub, args)
	case "readAssetPrivateDetails":
		return s.readAssetPrivateDetails(APIstub, args)
	case "createPrivateAssetImplicitForSeedsAssociation":
		return s.createPrivateAssetImplicitForSeedsAssociation(APIstub, args)
	case "createPrivateAssetImplicitForFarmersAssociation":
		return s.createPrivateAssetImplicitForFarmersAssociation(APIstub, args)
	case "queryPrivateDataHash":
		return s.queryPrivateDataHash(APIstub, args)
	default:
		return shim.Error("Invalid Smart Contract function name.")
	}

	// return shim.Error("Invalid Smart Contract function name.")
}

func (s *SmartContract) queryAsset(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	assetAsBytes, _ := APIstub.GetState(args[0])
	return shim.Success(assetAsBytes)
}

func (s *SmartContract) readPrivateAsset(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	// collectionAssets, collectionAssetPrivateDetails, _implicit_org_SeedsAssociationMSP, _implicit_org_FarmersAssociationMSP
	assetAsBytes, err := APIstub.GetPrivateData(args[0], args[1])
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get private details for " + args[1] + ": " + err.Error() + "\"}"
		return shim.Error(jsonResp)
	} else if assetAsBytes == nil {
		jsonResp := "{\"Error\":\"Asset private details does not exist: " + args[1] + "\"}"
		return shim.Error(jsonResp)
	}
	return shim.Success(assetAsBytes)
}


//-----------------------check usage----------------------------------
func (s *SmartContract) readPrivateAssetIMpleciteForSeedsAssociation(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	assetAsBytes, _ := APIstub.GetPrivateData("_implicit_org_SeedsAssociationMSP", args[0])
	return shim.Success(assetAsBytes)
}
//--------------------------------------------------------

func (s *SmartContract) readAssetPrivateDetails(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	assetAsBytes, err := APIstub.GetPrivateData("collectionAssetPrivateDetails", args[0])

	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get private details for " + args[0] + ": " + err.Error() + "\"}"
		return shim.Error(jsonResp)
	} else if assetAsBytes == nil {
		jsonResp := "{\"Error\":\"Asset private details does not exist: " + args[0] + "\"}"
		return shim.Error(jsonResp)
	}
	return shim.Success(assetAsBytes)
}

// func (s *SmartContract) test(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

// 	if len(args) != 1 {
// 		return shim.Error("Incorrect number of arguments. Expecting 1")
// 	}
// 	assetAsBytes, _ := APIstub.GetState(args[0])
// 	return shim.Success(assetAsBytes)
// }

func (s *SmartContract) initLedger(APIstub shim.ChaincodeStubInterface) sc.Response {
	assets := []Asset{
		Asset{Item:"Wheat", Subtype1: "Sharbati", Subtype2: "", Quantity: "50",  QuantityUnit: "kg",  Type: "Grain",  Organic: true, Owner:"Chaincoders", CreationTimestamp: time.now(),}
	}

	i := 0
	for i < len(assets) {
		assetAsBytes, _ := json.Marshal(assets[i])
		APIstub.PutState("ASSET"+strconv.Itoa(i), assetAsBytes)
		i = i + 1
	}

	return shim.Success(nil)
}

func (s *SmartContract) createPrivateAsset(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	type assetTransientInput struct {
		Item   string `json:"item"`
		Subtype1   string `json:"subtype1"`
		Subtype2   string `json:"subtype2"`
		Quantity   int `json:"quantity"`
		QuantityUnit  string `json:"quantityunit"`
		Type   string `json:"type"`
		Organic   string `json:"organic"`
		Owner   string `json:"owner"`
		CreationTimestamp   time.Time  `json:"creationtimestamp"`
		Price string `json:"price"`
		Key   string `json:"key"`
	}
	if len(args) != 0 {
		return shim.Error("111----Incorrect number of arguments. Private asset data must be passed in transient map.")
	}

	logger.Infof("11111111111111111111111111")

	transMap, err := APIstub.GetTransient()
	if err != nil {
		return shim.Error("222 -Error getting transient: " + err.Error())
	}

	assetDataAsBytes, ok := transMap["asset"]
	if !ok {
		return shim.Error("asset must be a key in the transient map")
	}
	logger.Infof("222   " + string(assetDataAsBytes))

	if len(assetDataAsBytes) == 0 {
		return shim.Error("333333 -asset value in the transient map must be a non-empty JSON string")
	}

	logger.Infof("222")

	var assetTransientInput assetInput
	err = json.Unmarshal(assetDataAsBytes, &assetInput)
	if err != nil {
		return shim.Error("44444 -Failed to decode JSON of: " + string(assetDataAsBytes) + "Error is : " + err.Error())
	}

	logger.Infof("333")

	if len(assetInput.Key) == 0 {
		return shim.Error("key field must be a non-empty string")
	}
	if len(assetInput.Item) == 0 {
		return shim.Error("Item field must be a non-empty string")
	}
	if len(assetInput.Quantity) == 0 {
		return shim.Error("Quantity field must be a non-empty string")
	}
	if len(assetInput.QuantityUnit) == 0 {
		return shim.Error("QuantityUnit field must be a non-empty string")
	}
	if len(assetInput.Owner) == 0 {
		return shim.Error("owner field must be a non-empty string")
	}
	if len(assetInput.Price) == 0 {
		return shim.Error("price field must be a non-empty string")
	}
	if len(assetInput.CreationTimestamp) == 0 {
		return shim.Error("time field must be a non-empty string")
	}

	
	logger.Infof("444")

	// ==== Check if asset already exists ====
	assetAsBytes, err := APIstub.GetPrivateData("collectionAssets", assetInput.Key)
	if err != nil {
		return shim.Error("Failed to get asset: " + err.Error())
	} else if assetAsBytes != nil {
		fmt.Println("This asset already exists: " + assetInput.Key)
		return shim.Error("This asset already exists: " + assetInput.Key)
	}

	logger.Infof("555")

	// var asset = Asset{Make: assetInput.Make, Model: assetInput.Model, Colour: assetInput.Color, Owner: assetInput.Owner}
	var asset := assetInput
	assetAsBytes, err = json.Marshal(asset)
	if err != nil {
		return shim.Error(err.Error())
	}
	err = APIstub.PutPrivateData("collectionAssets", assetInput.Key, assetAsBytes)
	if err != nil {
		logger.Infof("666")
		return shim.Error(err.Error())
	}

	assetPrivateDetails := &assetPrivateDetails{Owner: assetInput.Owner, Price: assetInput.Price}

	assetPrivateDetailsAsBytes, err := json.Marshal(assetPrivateDetails)
	if err != nil {
		logger.Infof("777")
		return shim.Error(err.Error())
	}

	err = APIstub.PutPrivateData("collectionAssetPrivateDetails", assetInput.Key, assetPrivateDetailsAsBytes)
	if err != nil {
		logger.Infof("888")
		return shim.Error(err.Error())
	}

	return shim.Success(assetAsBytes)
}

func (s *SmartContract) updatePrivateData(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	type assetTransientInput struct {
		Owner string `json:"owner"`
		Price string `json:"price"`
		Key   string `json:"key"`
	}
	if len(args) != 0 {
		return shim.Error("111----Incorrect number of arguments. Private asset data must be passed in transient map.")
	}

	logger.Infof("upd111")

	transMap, err := APIstub.GetTransient()
	if err != nil {
		return shim.Error("222 -Error getting transient: " + err.Error())
	}

	assetDataAsBytes, ok := transMap["asset"]
	if !ok {
		return shim.Error("asset must be a key in the transient map")
	}
	logger.Infof("****************  " + string(assetDataAsBytes))

	if len(assetDataAsBytes) == 0 {
		return shim.Error("333 -asset value in the transient map must be a non-empty JSON string")
	}

	logger.Infof("upd222")

	var assetTransientInput assetInput
	err = json.Unmarshal(assetDataAsBytes, &assetInput)
	if err != nil {
		return shim.Error("44444 -Failed to decode JSON of: " + string(assetDataAsBytes) + "Error is : " + err.Error())
	}

	assetPrivateDetails := &assetPrivateDetails{Owner: assetInput.Owner, Price: assetInput.Price}

	assetPrivateDetailsAsBytes, err := json.Marshal(assetPrivateDetails)
	if err != nil {
		logger.Infof("77777")
		return shim.Error(err.Error())
	}

	err = APIstub.PutPrivateData("collectionAssetPrivateDetails", assetInput.Key, assetPrivateDetailsAsBytes)
	if err != nil {
		logger.Infof("888888")
		return shim.Error(err.Error())
	}

	return shim.Success(assetPrivateDetailsAsBytes)

}


func (s *SmartContract) createAsset(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 10 {
		return shim.Error("Incorrect number of arguments. Expecting 10")
	}

	var asset = Asset{Item:args[1], Subtype1: args[2], Subtype2: args[3], Quantity: args[4],  QuantityUnit: args[5],  Type: args[6],  Organic: args[7], Owner: args[8], CreationTimestamp: args[9],}

	assetAsBytes, _ := json.Marshal(asset)
	APIstub.PutState(args[0], assetAsBytes)

	indexName := "owner~item"
	ownerItemIndexKey, err := APIstub.CreateCompositeKey(indexName, []string{asset.Owner, asset.Item})
	if err != nil {
		return shim.Error(err.Error())
	}
	value := []byte{0x00}
	APIstub.PutState(ownerItemIndexKey, value)

	return shim.Success(assetAsBytes)
}

func (S *SmartContract) queryAssetsByOwner(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments")
	}
	owner := args[0]

	ownerAndIdResultIterator, err := APIstub.GetStateByPartialCompositeKey("owner~item", []string{owner})
	if err != nil {
		return shim.Error(err.Error())
	}

	defer ownerAndIdResultIterator.Close()

	var i int
	var id string

	var assets []byte
	bArrayMemberAlreadyWritten := false

	assets = append([]byte("["))

	for i = 0; ownerAndIdResultIterator.HasNext(); i++ {
		responseRange, err := ownerAndIdResultIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}

		objectType, compositeKeyParts, err := APIstub.SplitCompositeKey(responseRange.Key)
		if err != nil {
			return shim.Error(err.Error())
		}

		id = compositeKeyParts[1]
		assetAsBytes, err := APIstub.GetState(id)

		if bArrayMemberAlreadyWritten == true {
			newBytes := append([]byte(","), assetAsBytes...)
			assets = append(assets, newBytes...)

		} else {
			// newBytes := append([]byte(","), assetsAsBytes...)
			assets = append(assets, assetAsBytes...)
		}

		fmt.Printf("Found a asset for index : %s asset id : ", objectType, compositeKeyParts[0], compositeKeyParts[1])
		bArrayMemberAlreadyWritten = true

	}

	assets = append(assets, []byte("]")...)

	return shim.Success(assets)
}

func (s *SmartContract) queryAllAssets(APIstub shim.ChaincodeStubInterface) sc.Response {

	startKey := ""
	endKey := ""

	resultsIterator, err := APIstub.GetStateByRange(startKey, endKey)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing QueryResults
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("- queryAllAssets:\n%s\n", buffer.String())

	return shim.Success(buffer.Bytes())
}

func (s *SmartContract) restictedMethod(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	// get an ID for the client which is guaranteed to be unique within the MSP
	//id, err := cid.GetID(APIstub) -

	// get the MSP ID of the client's identity
	//mspid, err := cid.GetMSPID(APIstub) -

	// get the value of the attribute
	//val, ok, err := cid.GetAttributeValue(APIstub, "attr1") -

	// get the X509 certificate of the client, or nil if the client's identity was not based on an X509 certificate
	//cert, err := cid.GetX509Certificate(APIstub) -

	val, ok, err := cid.GetAttributeValue(APIstub, "role")
	if err != nil {
		// There was an error trying to retrieve the attribute
		shim.Error("Error while retriving attributes")
	}
	if !ok {
		// The client identity does not possess the attribute
		shim.Error("Client identity does not posses the attribute")
	}
	// Do something with the value of 'val'
	if val != "approver" {
		fmt.Println("Attribute role: " + val)
		return shim.Error("Only user with role as APPROVER has access to this method!")
	} else {
		if len(args) != 1 {
			return shim.Error("Incorrect number of arguments. Expecting 1")
		}

		assetAsBytes, _ := APIstub.GetState(args[0])
		return shim.Success(assetAsBytes)
	}

}

func (s *SmartContract) changeAssetOwner(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	assetAsBytes, _ := APIstub.GetState(args[0])
	asset := Asset{}

	json.Unmarshal(assetAsBytes, &asset)
	asset.Owner = args[1]

	assetAsBytes, _ = json.Marshal(asset)
	APIstub.PutState(args[0], assetAsBytes)

	return shim.Success(assetAsBytes)
}

func (t *SmartContract) getHistoryForAsset(stub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) < 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	assetKey := args[0]

	resultsIterator, err := stub.GetHistoryForKey(assetKey)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing historic values for the asset
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"TxId\":")
		buffer.WriteString("\"")
		buffer.WriteString(response.TxId)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Value\":")
		// if it was a delete operation on given key, then we need to set the
		//corresponding value null. Else, we will write the response.Value
		//as-is (as the Value itself a JSON asset)
		if response.IsDelete {
			buffer.WriteString("null")
		} else {
			buffer.WriteString(string(response.Value))
		}

		buffer.WriteString(", \"Timestamp\":")
		buffer.WriteString("\"")
		buffer.WriteString(time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String())
		buffer.WriteString("\"")

		buffer.WriteString(", \"IsDelete\":")
		buffer.WriteString("\"")
		buffer.WriteString(strconv.FormatBool(response.IsDelete))
		buffer.WriteString("\"")

		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("- getHistoryForAsset returning:\n%s\n", buffer.String())

	return shim.Success(buffer.Bytes())
}

func (s *SmartContract) createPrivateAssetImplicitForSeedsAssociation(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 10 {
		return shim.Error("Incorrect arguments. Expecting 10 arguments")
	}
	var asset = Asset{Item:args[1], Subtype1: args[2], Subtype2: args[3], Quantity: args[4],  QuantityUnit: args[5],  Type: args[6],  Organic: args[7], Owner: args[8], CreationTimestamp: args[9],}
	
	assetAsBytes, _ := json.Marshal(asset)
	// APIstub.PutState(args[0], assetAsBytes)

	err := APIstub.PutPrivateData("_implicit_org_SeedsAssociationMSP", args[0], assetAsBytes)
	if err != nil {
		return shim.Error("Failed to add asset: " + args[0])
	}
	return shim.Success(assetAsBytes)
}

func (s *SmartContract) createPrivateAssetImplicitForFarmersAssociation(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 10 {
		return shim.Error("Incorrect arguments. Expecting 10 arguments")
	}

	var asset = Asset{Item:args[1], Subtype1: args[2], Subtype2: args[3], Quantity: args[4],  QuantityUnit: args[5],  Type: args[6],  Organic: args[7], Owner: args[8], CreationTimestamp: args[9],}


	assetAsBytes, _ := json.Marshal(asset)
	APIstub.PutState(args[0], assetAsBytes)

	err := APIstub.PutPrivateData("_implicit_org_FarmersAssociationMSP", args[0], assetAsBytes)
	if err != nil {
		return shim.Error("Failed to add asset: " + args[0])
	}
	return shim.Success(assetAsBytes)
}


//arg0 is collection name, arg 1 is key
// getPrivateDataHash returns the hash of the value of the specified `key` from the specified `collection`.
func (s *SmartContract) queryPrivateDataHash(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	assetAsBytes, _ := APIstub.GetPrivateDataHash(args[0], args[1])
	return shim.Success(assetAsBytes)
}


// The main function is only relevant in unit test mode. Only included here for completeness.
func main() {

	// Create a new Smart Contract
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
