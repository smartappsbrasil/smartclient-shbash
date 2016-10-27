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
# function for disconnect
#
smartDisconnect;
