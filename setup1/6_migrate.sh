#!/bin/sh

pushd ../
git add .
git commit -m "Distribute Crypto Material"
git push -u origin main
popd

