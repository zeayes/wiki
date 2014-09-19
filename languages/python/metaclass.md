#### python元类(metaclass)

##### 1、`type`
```python
Test = type("Test", (object,), {"attr": "test attr"})
test = Test()
print Test, type(Test), Test.attr
print test, type(test), test.attr
```

结果：
```sh
<class '__main__.Test'> <type 'type'> test attr
<__main__.Test object at 0x106a4e350> <class '__main__.Test'> test attr
```
说明：

>`type`通过类名(`Test`)、父类(`(object,)`）、属性（`{"attr": "test attr"}`）创建对象`Test`。


##### 2、`metaclass`

```python
# -*- coding: utf-8 -*-

class Meta(type):

    def __new__(cls, name, bases, attrs):
        print "inside Meta __new__"
        return super(Meta, cls).__new__(cls, name, bases, attrs)

    def __init__(self, name, bases, attrs):
        print "inside Meta __init__"
        return super(Meta, self).__init__(self)

    def __call__(self, *args, **kwargs):
        print "inside Meta __call__"
        return super(Meta, self).__call__(*args, **kwargs)

def decorator(cls):
    print "inside decorator"
    return cls

@decorator
class Test(object):
    __metaclass__ = Meta

    def __new__(cls):
        print "inside Test __new__"
        return super(Test, cls).__new__(cls)

    def __init__(self):
        print "inside Test __init__"
        return super(Test, self).__init__(self)


test = Test()
print "Object test: ", test
```

结果：
```sh
inside Meta __new__
inside Meta __init__
inside decorator
inside Meta __call__
inside Test __new__
inside Test __init__
Object test:  <__main__.Test object at 0x10aa87e90>
```

说明：

1、`python`首先会检查类申明，准备三个参数（类名、父类、属性）创建类。

2、检查类`__metaclass__`属性。如果设置了该属性，则调用`metaclass`，传递类创建三元组，并返回类对象。

3、调用`metaclass`时，创建`metaclass`。

4、检查类装饰器，处理类装饰器逻辑，并返回类对象。

5、当`Test`创建对象的时候，会调用`Meta`的`__call__`方法，并返回对象。

6、调用`Test.__new__`创建对象。

7、调用`Test.__init__`初始化对象。