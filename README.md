# SMARTAPPS API Client sh/bash
This library is for developers that want integrate linux systems with S.M.A.R.T.

## Libraries dependencies
- jq (se how to install it here: http://stedolan.github.io/jq)
- tr

Note: check if you have installed libraries above on your Linux.

## Examples
Check the **examples** folder to see how you can integrate on S.M.A.R.T.

## Functions

##### smartConnect $app
Function to estabilish a connection

####### Params
	$app 			: Application you can connect

##### smartDisconnect
Function to close a connection opened

##### smartGetData $schema $instruction
Function to get data from a form

####### Params
	$schema 		: Data schema you want load
	$instruction	: Instructions to load data (see more details on SMARTAPPS API Docs)

##### smartGetSchemas
Function to get schemas avaiable application

##### smartGetForms $schema
Function to get forms avaiable application

####### Params
	$schema 		: Schema of data

##### smartGetMethods $return $schema
Function to show methods of a application

####### Params
	$return 		: Type of request return. (json/csv)
	$schema 		: Schema of data

##### smartSendDataExec $return $schema $method $postVars (optional: $app)
Function to send data using exec process.

####### Params
	$return 		: Type of request return. (json/csv)
	$schema 		: Schema of data
	$method 		: Method you want execute to send array data
	$postVars		: string serialized of data to send for a application
	$app 			: Application. The argument it's optional, you can use to change app name.

##### smartExecMethod $return $schema $method (optional: $app)
Function to make a request using exec process.

####### Params
	$return 		: Type of request return. (json/csv)
	$schema 		: Schema of data
	$method 		: Method you want execute to send array data
	$app 			: Application. The argument it's optional, you can use to change app name.

## Variables

##### $smartResponseData
This variable is been declared every time you make a request. To get the result of last request you need use it.

## Tests
This library has been tested on CentOS 5 and CentOS 6.

@author José Wilker <jose.wilker@smartapps.com.br>

