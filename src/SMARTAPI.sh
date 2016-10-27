#!/bin/bash
# set variables

#
# SMARTAPPS CLIENT API ShellScript/Bash
#
# - Requirements
#	- jq
#	- tr
#
# @author José Wilker <jose.wilker@smartapps.com.br>
#

declare smApiUrl="http://www.smartapps.com.br/api/fp";
declare smApiUser="";
declare smApiKey="";

declare API_URL=${smartApiUrl:-$smApiUser};
declare API_USER=${smartApiUser:-$smApiKey};
declare API_KEY=${smartApiKey:-$API_KEY};

declare NODE="from";

VB=${smartVerbose:-0};

if [ -z $API_URL ]; then
	echo "You need declare the variable 'smartApiUrl' in your base file.";
	exit;
fi

if [ -z $API_USER ]; then
	echo "You need declare the variable 'smartApiUser' on your base file.";
	exit;
fi

if [ -z $API_KEY ]; then
	echo "You need declare the variable 'smartApiKey' on your base file.";
	exit;
fi

function smartHeaderPrint() {
	# Usage details
	echo "";
	echo "##########################################"
	echo " S.M.A.R.T - $1";
	echo "##########################################";
	echo "";
}

############################################################
#					Public functions					   #
############################################################

## Function to connect
function smartConnect() {

	if [ $# == 0 ]; then

		smartHeaderPrint "Connect";

		echo "How to use: sh $0 'APP_NAME'";
		echo "Definições:";
		echo " - APP_NAME		: Application are installed on environment and that user have permission to access.";

		exit;

	fi

	if [ $VB == 1 ]; then echo "Connecting S.M.A.R.T ..."; fi
	smartConn="$(curl -s $API_URL/$NODE/$1 --user $API_USER:$API_KEY)";
	echo curl -s $API_URL/$NODE/$1 --user $API_USER:$API_KEY;
	echo $smartConn > ".temp.auth.json";

	smartAppName=$1;
	smartAuthFile="$(cat .temp.auth.json)";

	smartAuthId="$(echo $(echo $smartAuthFile | jq '.data.id') | tr -d '"')";
	smartAuthName="$(echo $(echo $smartAuthFile | jq '.data.name') | tr -d '"')";

	sysCookie="$smartAuthName=$smartAuthId";

	rm -rf .temp.auth.json;

	if [ $VB == 1 ]; then echo "Connected!"; fi

}

## Function to disconnect
function smartDisconnect() {

	if [ $VB == 1 ]; then echo "Leaving..."; fi

	smartConnClose="$(curl -s $API_URL/close --user $API_USER:$API_KEY --cookie '$sysCookie')";
	statusRequest="$(echo $smartConnClose | jq '.data.status' | tr -d '"')";

	unset sysCookie;

	if [ $VB == 1 -a $statusRequest == "sucess" ]; then
		echo "Done!";
	else
		echo "Close failed!";
	fi

}

# Function to get data
function smartGetData() {

	saMethoDesc="data form";

	if [ ! $1 ]; then "arg one, You need specify a schema."; exit; fi
	if [ ! $2 ]; then "arg two, You need specify a instruction."; exit; fi

	appName=${3:-$smartAppName};

	_saGet $appName $1 $2;

	if [ $statusRequest -eq 1 ]; then
		return 1;
	else
		return 0;
	fi;

}

# Function to get Schemas
function smartGetSchemas() {

	saMethoDesc="schemas";

	appName=${1:-$smartAppName};

	_saGet $appName $1 '_schemas';

	if [ $statusRequest -eq 1 ]; then
		return 1;
	else
		return 0;
	fi;

}

# function to get schemas
function smartGetForms() {

	saMethoDesc="forms";

	if [ ! $1 ]; then "arg one, You need specify a schema."; exit; fi

	appName=${2:-$smartAppName};

	_saGet $appName $1 '_forms';

	if [ $statusRequest -eq 1 ]; then
		return 1;
	else
		return 0;
	fi;

}

# function to get schemas
function smartGetMethods() {

	typeExec="Getting";

	if [ ! $1 ]; then echo "arg one, You need specify type of return."; exit; fi
	if [ ! $2 ]; then echo "arg two, You need specify schema."; exit; fi

	appName=${3:-$smartAppName};

	_saExec $1 $2 '_methods' $appName;

	if [ $statusRequest -eq 1 ]; then
		return 1;
	else
		return 0;
	fi;

}

# function to send data exec a method
function smartSendDataExec() {

	typeExec="Running";

	if [ ! $1 ]; then echo "arg one, You need specify type of return."; exit; fi
	if [ ! $2 ]; then echo "arg two, You need specify schema."; exit; fi
	if [ ! $3 ]; then echo "arg three, You need specify method."; exit; fi
	if [ ! $4 ]; then echo "arg four, You need specify post vars."; exit; fi

	appName=${5:-$smartAppName};

	_saSendExec $1 $2 $3 $4 $appName;

	if [ $statusRequest -eq 1 ]; then
		return 1;
	else
		return 0;
	fi;

}

# function to execute a method
function smartExecMethod() {

	typeExec="Running";

	if [ ! $1 ]; then echo "arg one, You need specify type of return."; exit; fi
	if [ ! $2 ]; then echo "arg two, You need specify schema."; exit; fi
	if [ ! $3 ]; then echo "arg three, You need specify method."; exit; fi

	appName=${4:-$smartAppName};

	_saExec $1 $2 $3 $appName;

	if [ $statusRequest -eq 1 ]; then
		return 1;
	else
		return 0;
	fi;

}

############################################################
#					Private functions					   #
############################################################

# Function for exec a method with GET request.
function _saExec() {

	if [ $VB == 1 ]; then echo "- $typeExec method ... (#:$3)"; fi

	NODE="exec";

	smartRequest="$(curl -s $API_URL/$NODE/$1/$4/$2/$3 --user $API_USER:$API_KEY --cookie "$sysCookie")";

	typeReturn=$1;

	if [ $typeReturn == 'json' ]; then
		smartResponseData="$( echo $smartRequest | jq '.data')";
	else
		smartResponseData="$( echo $smartRequest )";
	fi;

	if [ ! "$smartResponseData" ]; then
		statusRequest=0;
		smartResponseData="ERROR: Cannot load data! Check vars sended.";
	else
		statusRequest=1;
	fi;

}

# Function for exec a method with POST request.
function _saSendExec() {

	if [ $VB == 1 ]; then echo "- Sending data ... (#:$3)"; fi

	NODE="exec";
	echo $API_URL/$NODE/$1/$5/$2/$3 --user $API_USER:$API_KEY --cookie "$sysCookie" --data "$4";
	smartRequest="$(curl -s $API_URL/$NODE/$1/$5/$2/$3 --user $API_USER:$API_KEY --cookie "$sysCookie" --data "$4")";

	typeReturn=$1;

	if [ $typeReturn == 'json' ]; then
		smartResponseData="$( echo $smartRequest | jq '.data')";
	else
		smartResponseData="$( echo $smartRequest )";
	fi;

	if [ ! "$smartResponseData" ]; then
		statusRequest=0;
		smartResponseData="ERROR: Cannot load data! Check vars sended.";
	else
		statusRequest=1;
	fi;

}

# Function to get data using GET request.
function _saGet() {

	x=$3;
	if [ -z $3 ]; then
		x=$2;
	fi;

	if [ $VB == 1 ]; then echo "- Getting $saMethoDesc ... (#:$x)"; fi

	NODE="from";

	smartRequest="$(curl -s $API_URL/$NODE/$1/$2/$3 --user $API_USER:$API_KEY --cookie "$sysCookie")";
	smartResponseData="$( echo $smartRequest | jq '.data')";

	if [ ! "$smartResponseData" ]; then
		statusRequest=0;
		smartResponseData="ERROR: Cannot load data! Check vars sended.";
	else
		statusRequest=1;
	fi;

}