#!/bin/sh

pushd ../
git add .
git commit -m "Distribute Crypto Material"
git checkout master
git push -u origin master
popd

