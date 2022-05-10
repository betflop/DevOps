# gRPC сервер и клиен на golang с прокси REST api через grpc-gateway 

### Запуск компиляции proto файлов под golang через докер образ namely/protoc-all
### создает папку gen
'''
-o - директория, куда будут скомпилированы proto stubs.
-i - путь к сторонним зависимостям, в нашем случае googleapis
-l - ЯП, в нашем случае Golang (go)
флаг --with-gateway, для генерации RESTful API
'''
'''
docker-compose -f docker-compose.yml up
'''

## Запуск сервисов
'''go
go run server/main.go
go run client/main.go 
'''
