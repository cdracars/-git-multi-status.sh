#!/bin/bash

for i in *.git ; do
	( cd $i
		RES=$(git status | grep -E '^# (Changes|Changed|Untracked)')
		STAT=""
		grep -e 'Untracked' <<<${RES} >/dev/null 2>&1
		if [ $? -eq 0 ] ; then
			STAT="[Untracked]"
		fi
		grep -e 'Changed' <<<${RES} >/dev/null 2>&1
		if [ $? -eq 0 ] ; then
			STAT="$STAT [Modified]"
		fi
		grep -e 'Changes' <<<${RES} >/dev/null 2>&1
		if [ $? -eq 0 ] ; then
			STAT="$STAT [Staged]"
		fi

		if [ -n "$STAT" ] ; then
			echo "$i : $STAT"
		fi
	)
done
