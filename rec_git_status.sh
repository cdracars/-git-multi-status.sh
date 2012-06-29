#!/bin/bash

# usage: $0 source_dir [source_dir] ...
# where source_dir args are directories containing git repositories

for i in $@ ; do
  for gitdir in `find $i -name .git` ; do
    ( working=$(dirname $gitdir)
      cd $working
      RES=$(git status | grep -E '^# (Changes|Untracked|Your branch)')
      STAT=""
      grep -e 'Untracked' <<<${RES} >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        STAT=" [Untracked]"
      fi
      grep -e 'Changes not staged for commit' <<<${RES} >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        STAT="$STAT [Modified]"
      fi
      grep -e 'Changes to be committed' <<<${RES} >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        STAT="$STAT [Staged]"
      fi
      grep -e 'Your branch is ahead' <<<${RES} >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        STAT="$STAT [Unpushed]"
      fi
      grep -e 'Your branch is behind' <<<${RES} >/dev/null 2>&1
      if [ $? -eq 0 ] ; then
        STAT="$STAT [Unmerged]"
      fi

      if [ -n "$STAT" ] ; then
        echo "$working :$STAT"
      fi
    )
  done
done
