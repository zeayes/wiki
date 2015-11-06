package main

import (
	"fmt"
	"os"

	"../gen-go/rpc"

	"git.apache.org/thrift.git/lib/go/thrift"
)

const (
	ServerAddr = "127.0.0.1:19090"
)

type Server struct{}

func (s *Server) FuncCall(callTime int64, funcCode string, paramMap map[string]string) (r []string, err error) {
	fmt.Println("--> FuncCall: ", callTime, funcCode, paramMap)

	for k, v := range paramMap {
		r = append(r, k+v)
	}

	return
}

func main() {
	transportFactory := thrift.NewTFramedTransportFactory(thrift.NewTTransportFactory())
	protocolFactory := thrift.NewTBinaryProtocolFactoryDefault()

	serverTransport, err := thrift.NewTServerSocket(ServerAddr)
	if err != nil {
		fmt.Println("server transport error: ", err)
		os.Exit(1)
	}

	processor := rpc.NewSerivceProcessor(&Server{})
	server := thrift.NewTSimpleServer4(processor, serverTransport, transportFactory, protocolFactory)
	fmt.Println("thrift server in ", ServerAddr)
	server.Serve()
}
