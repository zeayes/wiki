#!/bin/bash

# 对第三列求和
awk -F "," '{sum+=$3} END {print sum}' test.csv

# 对第三列匹配求和
awk -F "," ' $3 ~ /^CG/ {sum+=$5} END { print sum}' test.csv

