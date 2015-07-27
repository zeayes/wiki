### HTTP协议详解

HTTP协议主要有2部分组成：**请求(Request)**和**响应(Response)**。

#### 请求(Request)
HTTP请求主要由以下部分组成：请求行、请求头和请求体三部分组成。

##### 请求行
> Method Request-URI HTTP/Version CRLF

`GET /index.html HTTP/1.1`

##### 请求头
请求头是客户端向服务端传递的请求附加信息，格式如下：
> key: value

##### 请求体

#### 响应(Response)
HTTP响应也是由以下三部分组成：响应行、响应头和响应体。

##### 响应行
> HTTP/Version Status-Code Reason-Phrase CRLF

`HTTP/1.1 400 BAD REQUEST`