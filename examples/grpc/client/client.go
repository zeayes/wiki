package main

import (
	"fmt"
	"io"
	"log"

	"../proto"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

func main() {
	conn, err := grpc.Dial("127.0.0.1:54321")
	if err != nil {
		log.Fatalf("failed to dail server: %v", err)
	}
	defer conn.Close()

	client := proto.NewUserServiceClient(conn)

	userId := proto.UserId{Id: 10001}
	resp, err := client.GetUser(context.Background(), &userId)
	if err != nil {
		log.Fatalf("Service GetUser error: %v", err)
	}
	fmt.Println("Service GetUser response is: ", resp)

	userIds := proto.UserIds{Id: []int32{10001, 10002}}
	stream, err := client.ListUsers(context.Background(), &userIds)
	for {
		user, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatalf("Service ListUsers Recv error: %v", err)
		}
		fmt.Println("Service ListUsers user: ", user)
	}
}
