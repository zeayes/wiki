#!/bin/bash

git clone https://github.com/etsy/statsd/
cd statsd
npm install
./run_tests.sh
