package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"

	"example.gateway/gen/pb-go/pb"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type server struct {
	pb.UnimplementedGatewayServer
}

// curl -d '{"id":"22"}' -H "Content-Type: application/json"  -X POST http://localhost:8888/post
func (s *server) PostExample(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	fmt.Println("hello it is post")
	fmt.Println(in)
	return &pb.Message{Id: 100 + in.Id}, nil
}

// curl -X GET http://localhost:8888/get/1
func (s *server) GetExample(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	fmt.Println(in)
	return &pb.Message{Id: 100 + in.Id}, nil
}

func (s *server) DeleteExample(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	fmt.Println(in)
	return &pb.Message{Id: 100 + in.Id}, nil
}

func (s *server) PutExample(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	fmt.Println(in)
	return &pb.Message{Id: 100 + in.Id}, nil
}

func (s *server) PatchExample(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	fmt.Println(in)
	return &pb.Message{Id: 100 + in.Id}, nil
}

func runRest() {
	// Пакет context в go позволяет вам передавать данные в вашу программу в каком-то «контексте».
	ctx := context.Background()
	// Эта функция возвращает пустой контекст.
	// Она должна использоваться только на высоком уровне
	// (в main или обработчике запросов высшего уровня).
	// Он может быть использован для получения других контекстов,
	ctx, cancel := context.WithCancel(ctx)
	// Эта функция создает новый контекст из переданного ей родительского.
	// Родителем может быть контекст background или контекст, переданный в качестве аргумента функции.
	// Возвращается производный контекст и функция отмены.
	defer cancel()
	mux := runtime.NewServeMux()
	// ServeMux - это мультиплексор HTTP-запросов.
	// Он сопоставляет URL-адрес каждого входящего запроса со списком
	// зарегистрированных шаблонов и вызывает обработчик для шаблона,
	// который наиболее точно соответствует URL-адресу.
	// NewServeMux выделяет и возвращает новый ServeMux.
	opts := []grpc.DialOption{grpc.WithTransportCredentials(insecure.NewCredentials())}
	// DialOptions для установки метода аутентификации в grpc
	// grpc.WithTransportCredentials: Настройте учетные данные безопасности уровня соединения (например, TLS / SSL) и верните DialOption для подключения к серверу.
	err := pb.RegisterGatewayHandlerFromEndpoint(ctx, mux, "localhost:12201", opts)
	if err != nil {
		panic(err)
	}
	log.Printf("server REST listening at 8888")
	if err := http.ListenAndServe(":8888", mux); err != nil {
		panic(err)
	}
}

func runGrpc() {
	lis, err := net.Listen("tcp", ":12201")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGatewayServer(s, &server{})
	log.Printf("server GRPC listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		panic(err)
	}
}

func main() {
	go runRest()
	runGrpc()
}
