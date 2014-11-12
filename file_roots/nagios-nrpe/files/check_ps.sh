#! /bin/bash
#
# Author : DWS Team
# Desc : Plugin to verify a list of processes 
#
#

PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`

{%- if grains.get("os") in [ "CentOS", "Redhat" ] %}
PL=""
PL="crond $PL"
PL="/sbin/rsyslogd $PL"
PL="/usr/bin/salt-minion $PL" 
{%- else %}
PL=""
PL="cron $PL"
PL="rsyslogd $PL"
PL="/usr/bin/salt-minion $PL" 
{%- endif %}

. $PROGPATH/utils.sh

errored=""

for p in $PL; do
	out=`ps -ef | grep -v grep | grep $p`
	if [ $? -ne 0 ]; then
		errored="$p $errored"
	fi
done

if [ ! -z "$errored" ]; then
	echo "CRITICAL: Following processes not found: $errored"
	exit $STATE_CRITICAL
else
	echo "OK: All processes found"
	exit $STATE_OK
fi

