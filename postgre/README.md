# Postgresql в докере c Pgadmin и миграциями

#docker-compose -f docker-compose.yml up

### Ручной запуск миграции через докер
```
docker run -v /home/pk/Documents/DevOps/postgre/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://ozon:ozon@localhost:5432/ozon?sslmode=disable up 2
```
