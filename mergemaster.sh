#!/bin/sh

branch=`git branch | grep '^\*' | sed 's/^\* //g'`

git status

if [ "$?" = 0 ]; then
  echo "There are uncommentted changes to this branch"
  exit 1
fi

git checkout master
git merge $branch
git checkout $branch
