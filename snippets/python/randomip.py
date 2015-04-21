# -*- coding: utf-8 -*-

import struct
import socket
import random


def get_random_ip():
    return socket.inet_ntoa(struct.pack('>I', random.randint(1, 0xffffffff)))

if __name__ == '__main__':
    print get_random_ip()
