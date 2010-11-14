#!/bin/bash

if [ -z "$BASEDIR" ]; then
	export BASEDIR=$(cd `dirname $0`; pwd)
fi

export DATADIR="$BASEDIR/data"
export SCRIPTDIR="$BASEDIR/scripts"
export LOGDIR="$BASEDIR/log"

cd $BASEDIR

. ./include.sh

script="$1"
DEPLOY_SCRIPTS=''

# cleaning log directory
rm "$LOGDIR" -rf
mkdir -p "$LOGDIR"

IFS='
'

if [ -n "$script" ]; then
	# run a single script and it's dependencies
	depends "$script"
else
	# run all the executable scripts
	for filename in `ls -1 $BASEDIR/scripts/*`; do
		script=`basename "$filename"`
		depends "$script"
	done
fi

# check if something failed
cd $BASEDIR

rc=0
for logFile in `ls -1 log/*.[1-9]* 2> /dev/null`; do
	failedScript=`basename "$logFile"|sed 's/^\(.*\)\..*/\1/'`
	echo "Script '$failedScript' failed"
	rc=1
done

exit $rc
