#!/bin/bash

echo "Deploy $TRAVIS_BRANCH !"

set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

rev=$(git rev-parse --short HEAD)

REPONAME=`basename $PWD`
PARENTDIR=`dirname $PWD`
USERNAME=`basename $PARENTDIR`
cd out

git init
git config user.name "oXygen XML Deployer"
git config user.email "support@oxygenxml.com"

git remote add upstream "https://$GH_TOKEN@github.com/$USERNAME/$REPONAME.git"
git fetch upstream
git reset upstream/gh-pages

#touch .

ls
git status

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages