#!/bin/bash

mkdir k8comp
cp -R ../examples/defaults/* k8comp/
cp -R ../bin k8comp/
cp -R ../LICENSE k8comp/
cp -R ../README.md k8comp/
tar -cvzf k8comp.tar.gz k8comp
rm -rf k8comp
