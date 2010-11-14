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

# compiler
rm "$LOGDIR" -rf
mkdir -p "$LOGDIR"

IFS='
'

if [ -n "$script" ]; then
	depends "$script"
else
	for filename in `ls -1 $BASEDIR/scripts/*`; do
		script=`basename "$filename"`
		depends "$script"
	done
fi

