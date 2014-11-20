# -*- coding: utf-8 -*-

import struct
import socket

def ip2int(ip):
    return struct.unpack("!I", socket.inet_aton(ip))[0]

def int2ip(i):
    return socket.inet_ntoa(struct.pack("!I", i))

if __name__ == '__main__':
    ip = '192.168.60.107'
    print ip2int(ip)
    print int2ip(ip2int(ip))
