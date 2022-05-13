package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	pb "example.gateway/gen/pb-go/pb"
	// pb "github.com/matzhouse/go-grpc/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/grpclog"
)

func main() {
    opts := []grpc.DialOption{
        grpc.WithInsecure(),
    }
    args := os.Args
    conn, err := grpc.Dial("127.0.0.1:12201", opts...)

    if err != nil {
        grpclog.Fatalf("fail to dial: %v", err)
    }

    defer conn.Close()

    client := pb.NewGatewayClient(conn)
    // args[1]
    i, err := strconv.ParseUint(args[1], 10, 64)
    if err != nil {
        // handle error
        fmt.Println(err)
        os.Exit(2)
    }
    request := &pb.Message{Id: i}
    response, err := client.PostExample(context.Background(), request)

    if err != nil {
        grpclog.Fatalf("fail to dial: %v", err)
    }

    println("This is new response.Id ---")
   fmt.Println(response.Id)
}
