# -*- coding: utf-8 -*-


class Property(object):

    def __init__(self, fget=None, fset=None, fdel=None, doc=None):
        self.fget = fget
        self.fset = fset
        self.fdel = fdel
        if doc is None and fget is not None:
            doc = fget.__doc__
        self.__doc__ = doc

    def __get__(self, obj, objtype=None):
        if obj is None:
            return self
        if self.fget is None:
            raise AttributeError("unreadable attribute")
        return self.fget(obj)

    def __set__(self, obj, value):
        if self.fset is None:
            raise AttributeError("can't set attribute")
        self.fset(obj, value)

    def __delete__(self, obj):
        if self.fdel is None:
            raise AttributeError("can't delete attribute")
        self.fdel(obj)

    def getter(self, fget):
        return type(self)(fget, self.fset, self.fdel, self.__doc__)

    def setter(self, fset):
        return type(self)(self.fget, fset, self.fdel, self.__doc__)

    def deleter(self, fdel):
        return type(self)(self.fget, self.fset, fdel, self.__doc__)


class Field(object):

    def __init__(self, name, typ, default=None):
        self.name = "_" + name
        self.typ = typ
        self.default = default

    def __get__(self, instance, cls):
        return getattr(instance, self.name, self.default)

    def __set__(self, instance, value):
        if not isinstance(value, self.typ):
            raise TypeError("Must be a %s" % self.typ)
        setattr(instance, self.name, value)

    def __delete__(self, instance):
        raise AttributeError("Can't delete attribute")


class Person(object):
    name = Field("name", str)
    age = Field("age", int, 20)

zeayes = Person()
zeayes.name = "zeayes"
zeayes.age = 25
print zeayes.name, zeayes.age
# zeayes.age = 'test'


class Test(object):

    @Property
    def sender(self):
        return 10


test = Test()
print test.sender
test.sender = 20
print test.sender
