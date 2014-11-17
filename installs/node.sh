#!/bin/bash

cd /data/Downloads
wget http://nodejs.org/dist/v0.10.33/node-v0.10.33.tar.gz
tar xzf node-v0.10.33.tar.gz && cd node-v0.10.33
./configure --prefix=/usr/local/node-v0.10.33
make -j 8 && make install
ln -s /usr/local/node-v0.10.33/bin/node /usr/bin/node
ln -s /usr/local/node-v0.10.33/bin/npm /usr/bin/npm
