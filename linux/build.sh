#!/bin/bash

pushd ../node
make distclean
./configure --without-snapshot
CXXFLAGS=-fpermissive make
popd