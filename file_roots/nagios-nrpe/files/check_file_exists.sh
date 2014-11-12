#! /bin/bash
#
# Author : DWS Team
# Desc : Plugin to verify if a file NOT exists
#
#

PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`

. $PROGPATH/utils.sh

if [ "$1" = "" ]
then
	echo -e " Use : $PROGNAME <file_name> -- Ex : $PROGNAME /etc/hosts \n "
	exit $STATE_UNKNOWN
fi


if [ ! -f $1 ]
then
	echo "OK - $1 : NOT EXISTS"
	exit $STATE_OK
else
	echo "CRITICAL : $1 EXISTS"
	exit $STATE_CRITICAL
fi

