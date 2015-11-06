THRIFT Example written by Golang.
==========

run the example as follows:

1. run the server
```sh
go run server/server.go
```

2. run the client
```sh
go run client/client.go
```

3. generate server/client thrift code (directory `gen-go`)
```sh
# thrift -gen go service.go
thrift -gen go:thrift_import=git-wip-us.apache.org/repos/asf/thrift.git/lib/go/thrift service.go
```
