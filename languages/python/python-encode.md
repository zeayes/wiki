#### python编码问题

1. `str`只能表示latin字符，`unicode`能表示所有的字符。
2. `str`和`unicode`都继承自`basestring`。
3. py文件默认以`ascii`格式编码，可通过
	```
	# coding=utf8
	```
	或者
	```
	# -*- coding: utf8 -*-
	```
	声明文件编码格式。
4. python是以`unicode`作为中间编码进行转码的：```decode()```是将其他编码的字符串解码成```unicode```；```encode()```是将```unicode```编码的字符串转换为另外一种编码。

	```
	In [1]: a = "hello"

    In [2]: b = u"world"

    In [3]: isinstance(a, str)
    Out[3]: True

    In [4]: isinstance(b, str)
    Out[4]: False

    In [5]: isinstance(a, unicode)
    Out[5]: False

    In [6]: isinstance(b, unicode)
    Out[6]: True

    In [7]: isinstance(a, basestring)
    Out[7]: True

    In [8]: isinstance(b, basestring)
    Out[8]: True
    
    In [9]: a.decode("utf8")
    Out[9]: u'hello'
	
	In [10]: b.encode("ascii")
	Out[10]: 'world'
    ```
