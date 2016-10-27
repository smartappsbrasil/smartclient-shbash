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
# function for execute a method from app.
#
smartSendDataExec 'json' $wSchema 'variaveis_valores/insert' 'variavel=1&valor=23';
echo $smartResponseData;

#
# function for disconnect
#
smartDisconnect;
