#!/bin/bash
# Load smart api library
# Local path is ../src/SMARTAPI.sh


# Load globalVars and Load SMARTAPI
source ../smart.cfg

. ../src/SMARTAPI.sh

#
# first step: setup a app to connect. Before connect you can change app
#
smartConnect $wApp;

#
# Pay Atention! Now you can execute all functions, if want more details see: README.md
#

#
# function for data with basic request to a form
#
smartGetData $wSchema 'variaveis_valores/_last/1';
echo $smartResponseData;

#
# function for get schemas avaiables
#
smartGetSchemas;
echo $smartResponseData;

#
# function for get forms avaiable on a schema.
#
smartGetForms $wSchema;
echo $smartResponseData;

#
# function for get forms avaiable on a schema.
#
smartGetMethods 'json' $wSchema;
echo $smartResponseData;

#
# function for send basic string data with exec.
#
smartSendDataExec 'json' $wSchema 'variaveis_valores/insert' 'variavel=1&valor=9';
echo $smartResponseData;

#
# function for send multidimensional string data with exec.
#
smartSendDataExec 'json' $wSchema 'variaveis_valores/insert' 'variavel[]=1&valor[]=12&variavel[]=1&valor[]=22&tmd=1';
echo $smartResponseData;

#
# function for execute a method from app.
#
smartExecMethod 'json' $wSchema 'variaveis_valores/insert';
echo $smartResponseData;

#
# function for execute a method from app.
#
smartSendDataExec 'json' $wSchema 'variaveis_valores/insert' 'variavel=1&valor=23';
echo $smartResponseData;

#
# function for disconnect
#
smartDisconnect;
