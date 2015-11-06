package main

import (
	"fmt"
	"os"
	"time"

	"../gen-go/rpc"
	"git.apache.org/thrift.git/lib/go/thrift"
)

const (
	ServerAddr = "127.0.0.1:19090"
)

func main() {
	transportFactory := thrift.NewTFramedTransportFactory(thrift.NewTTransportFactory())
	protocolFactory := thrift.NewTBinaryProtocolFactoryDefault()

	transport, err := thrift.NewTSocket(ServerAddr)
	if err != nil {
		fmt.Println("create socket error: ", err)
		os.Exit(1)
	}

	useTransport := transportFactory.GetTransport(transport)
	client := rpc.NewSerivceClientFactory(useTransport, protocolFactory)
	if err := transport.Open(); err != nil {
		fmt.Println("open transport error: ", err)
		os.Exit(1)
	}
	defer transport.Close()

	paramMap := make(map[string]string)
	paramMap["name"] = "zeayes"
	paramMap["passwd"] = "123456"
	resp, err := client.FuncCall(time.Now().UnixNano(), "login", paramMap)
	if err != nil {
		fmt.Println("rpc call error: ", err)
		os.Exit(1)
	}
	fmt.Println("rpc call response: ", resp)
}
