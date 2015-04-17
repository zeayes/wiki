# -*- coding: utf-8 -*-

import re
import sys

'''
redis aof format:
    *num: num arguments
    $num: argument has num bytes
    INCRBY: argument conent

one complete command item as following:

*3
$6
INCRBY
$7
RC:user
$1
1
'''

def parse(filename):
    argnums = []
    values = []
    content = open(filename).read()
    parts = re.split('(\*\d\\r\\n)', content)[1:]
    for index, value in enumerate(parts):
        if index % 2:
            values.append(value)
        else:
            argnums.append(value)
    for argnum, data in zip(argnums, values):
        items = data.split('\r\n')
        # filter del command
        if items[0] == '$3' and items[1] == 'DEL' and items[3].startswith('tl:video:'):
            continue
        num = int(argnum.strip()[1])
        if num == 2:
            print items[1], items[3]
        elif num == 3:
            print items[1], items[3], items[5]
        elif num == 4:
            print items[1], items[3], items[5], items[7]

        # complete cmd item
        print argnum + data


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print 'please input filename'
        sys.exit(1)

    parse(sys.argv[1])
