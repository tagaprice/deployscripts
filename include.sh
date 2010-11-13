#!/bin/bash

if [ -z "$BASEDIR" ]; then
	export BASEDIR=$(cd `dirname $0`; pwd)
fi

export DATADIR="$BASEDIR/data"
export SCRIPTDIR="$BASEDIR/scripts"
export LOGDIR="$BASEDIR/log"

function depends() {
	script="$1"
	filename="$SCRIPTDIR/$script"
	logfile="$LOGDIR/$script"
	if [ -x "$filename" ]; then
		if [ -f "$logfile.0" ]; then
			true
		elif [ -f "$logfile".* ]; then
			echo "failed dependency: '$script' (in $0)" >&2
			exit 1
		else
			cd "$BASEDIR"

			# now that's ugly, but it works...  :)
			> $logfile
			(
				"$filename" 2>&1 
				mv "$logfile" "$logfile.$?"
			)| tee -a "$logfile"
		fi
	fi
}

function fail() {
	echo $* >&2
	exit 1
}
