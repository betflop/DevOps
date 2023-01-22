# gRPC сервер и клиент на golang с прокси REST api через grpc-gateway 

### Запуск компиляции proto файлов под golang через докер образ namely/protoc-all
### создает папку gen
```
-o - директория, куда будут скомпилированы proto stubs.
-i - путь к сторонним зависимостям, в нашем случае googleapis
-l - ЯП, в нашем случае Golang (go)
флаг --with-gateway, для генерации RESTful API
```

```
docker-compose -f docker-compose.yml up
```

## Запуск сервисов
```go
go run server/main.go
go run client/main.go 
```

# Postgresql в докере c Pgadmin и миграциями

#docker-compose -f docker-compose.yml up

### Ручной запуск миграции через докер
```
docker run -v /home/pk/Documents/DevOps/postgre/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://ozon:ozon@localhost:5432/ozon?sslmode=disable up 2
```

![graph](https://github.com/pavlyk/DevOps/blob/master/gateway/Screenshot_83.png)
