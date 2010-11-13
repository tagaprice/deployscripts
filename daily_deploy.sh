#!/bin/bash

. ./include.sh

script="$1"
DEPLOY_SCRIPTS=''

# compiler
cd $BASEDIR

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

