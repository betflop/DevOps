package main

import (
	"context"
	"log"
	"net"
	"net/http"

	_ "github.com/lib/pq"

	"example.gateway/gen/pb-go/pb"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	g "github.com/serpapi/google-search-results-golang"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	dbozon "example.gateway/pkg/dbozon"
)

type server struct {
	pb.UnimplementedGatewayServer
}

func (s *server) FindFilm(ctx context.Context, in *pb.Message) (*pb.Message, error) {

	var film string
	var img string
	film, img = dbozon.FindFilmPostgre(int(in.Id))	
	return &pb.Message{Id: in.Id, Film: film, Img: img}, nil

}

func (s *server) UpdateImage(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	dbozon.UpdateImagePostgre(int(in.Id), in.Img)	
	return &pb.Message{Id: in.Id, Film: in.Film, Img: in.Img}, nil
}

func (s *server) UpdateScore(ctx context.Context, in *pb.Message) (*pb.Message, error) {
// fmt.Printf("%v", res)
        result := dbozon.UpdateScorePostgre(int(in.UserId), in.UserName, int(in.Score), int(in.Result))
	return &pb.Message{Result: int64(result)}, nil
}

func (s *server) GetImage(ctx context.Context, in *pb.Message) (*pb.Message, error) {
	parameter := map[string]string{
		"q":   "Кадр из фильма " + in.Film,
		"tbm": "isch",
	}

	query := g.NewGoogleSearch(parameter, in.Api)

	rsp, err := query.GetJSON()
	println(err)
	results := rsp["images_results"].([]interface{})
	data := results[0].(map[string]interface{})
	// return data
	var img string
	if str, ok := data["original"].(string); ok {
		img = str
	}
	return &pb.Message{Id: in.Id, Film: in.Film, Img: img}, nil
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
