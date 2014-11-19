#!/bin/bash

cd /data/Downloads
wget https://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
tar xzf Python-2.7.3.tgz &&  cd Python-2.7.3
./configure --prefix=/usr/local/python-2.7.3
make -j 8 && make install

rm -f /usr/bin/python
ln -s /usr/local/python-2.7.3 /usr/local/python
ln -s /usr/local/python-2.7.3/bin/python /usr/bin/python2.7
ln -s /usr/local/python-2.7.3/bin/python /usr/bin/python
ln -s /usr/local/python-2.7.3/lib/python2.6 /usr/lib/python2.7
ln -s /usr/local/python-2.7.3/lib/python2.6 /usr/lib/python
ln -s /usr/local/python-2.7.3/lib/python2.6 /usr/lib64/python2.7
ln -s /usr/local/python-2.7.3/lib/python2.6 /usr/lib64/python
