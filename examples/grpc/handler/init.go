package handler

type Server struct{}

func NewServer() *Server {
	s := new(Server)
	return s
}
