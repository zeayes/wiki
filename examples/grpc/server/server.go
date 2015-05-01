package main

import (
	"log"
	"net"

	"../handler"
	"../proto"
	"google.golang.org/grpc"
)

func main() {
	lis, err := net.Listen("tcp", ":54321")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	proto.RegisterUserServiceServer(grpcServer, handler.NewServer())
	grpcServer.Serve(lis)
}
