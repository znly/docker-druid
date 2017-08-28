#!/bin/bash

SCRIPTPATH=`pwd -P`
. $SCRIPTPATH/.env

ACTION=$1
SOL_NAME=$2

function printHelp {
	echo "Deploy or undeploy a solution"
	echo
	echo " USAGE:"
	echo "   solution.sh deploy <solution_name>"
	echo "	    deploys the solution defined in docker-compose.yml and name it"
	echo
	echo "   solution.sh rm <solution_name>"
	echo "	    remove the solution <solution_name>"
	echo
	echo
	exit 0
}

if [ "$ACTION" = "" ] || [ "$ACTION" = "-h" ] || [ "$ACTION" = "help" ]; then
	printHelp
fi

if [ "$ACTION" = "deploy" ]; then
	docker stack deploy --with-registry-auth --compose-file docker-compose.yml $SOL_NAME
 
elif [ "$ACTION" = "rm" ]; then
	docker stack rm $SOL_NAME
else 
	echo "Unknown action: \"$ACTION\""
	echo
	printHelp
fi

