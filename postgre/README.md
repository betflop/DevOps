# Postgresql в докере c Pgadmin и миграциями


### Ручной запуск миграции через докер
docker run -v /home/pk/Documents/go/postgre/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://ozon:ozon@localhost:5432/ozon?sslmode=disable up 2

