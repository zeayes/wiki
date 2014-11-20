# -*- coding: utf-8 -*-

from nose.tools import with_setup

def setup():
    print "setup module"

def teardown():
    print "teardown module"

def func_setup():
    print "func setup"

def func_teardown():
    print "func teardown"

@with_setup(func_setup, func_teardown)
def test_func():
    print "test func"

class TestCase:

    def setup(self):
        print "setup in class"

    def teardown(self):
        print "teardown in class"

    def test_class(self):
        print "test class"
