# -*- coding: utf-8 -*-

class Singleton(type):

    def __init__(cls, name, bases, attrs):
        super(Singleton, cls).__init__(name, bases, attrs)
        cls.instance = None

    def __call__(cls, *args, **kwargs):
        if cls.instance is None:
            print 'creating a new instance'
            cls.instance = super(Singleton, cls).__call__(*args, **kwargs)
        else:
            print 'instance already exists'

class TestSingleton(object):

    __metaclass__ = Singleton


if __name__ == '__main__':
    a = TestSingleton()
    b = TestSingleton()
    print a is b
