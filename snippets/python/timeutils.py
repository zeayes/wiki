# -*- coding: utf-8 -*-

import time
import datetime

def stamp_to_datetime(s):
    return datetime.datetime.fromtimestamp(s)

def stamp_to_iso(s):
    return time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(s))

def datetime_to_stamp(d):
    return time.mktime(d.timetuple())

def datetime_to_iso(value):
    return value.strftime('%Y-%m-%dT%H:%M:%SZ')

def iso_to_stamp(s):
    return time.mktime(time.strptime(s, '%Y-%m-%dT%H:%M:%SZ'))

def iso_to_datetime(s):
    return datetime.datetime.strptime(s, '%Y-%m-%dT%H:%M:%SZ')

if __name__ == '__main__':
    stamp = time.time()
    print stamp_to_datetime(stamp)
    print stamp_to_iso(stamp)
