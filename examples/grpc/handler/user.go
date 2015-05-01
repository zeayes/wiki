package handler

import (
	pb "../proto"
	"golang.org/x/net/context"
)

func (s *Server) GetUser(ctx context.Context, request *pb.UserId) (*pb.User, error) {
	userId := request.Id
	return &pb.User{Id: userId, Name: "zeayes", Age: 25}, nil
}

func (s *Server) ListUsers(request *pb.UserIds, stream pb.UserService_ListUsersServer) error {
	userIds := request.Id
	for userId := range userIds {
		if err := stream.Send(&pb.User{Id: int32(userId), Name: "zeayes", Age: 25}); err != nil {
			return err
		}
	}
	return nil
}
