#!/usr/bin/env bash
# This script is part of my GeekTool setup, it creates a nicely-formatted count of the files in my Homework directory.

COUNT=`ls -1l ~/Documents/Homework | egrep -v "^d|^total" | wc -l | sed -e 's/^ *//'`
if [[ $COUNT == 1 ]]; then
    PLURAL="assignment"
else
    PLURAL="assignments"
fi

echo $COUNT $PLURAL remaining.
