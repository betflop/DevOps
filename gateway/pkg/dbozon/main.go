package dbozon

import (
	"context"
	"database/sql"
	"fmt"
	"log"
)

func FindFilmPostgre(id int) (film string, img string) {
	var (
		ctx2 = context.Background()
		dsn  = "user=ozon password=ozon dbname=ozon sslmode=disable"
	)
	db, err := sql.Open("postgres", dsn)
	db.SetMaxOpenConns(10)
	if err = db.PingContext(ctx2); err != nil {
		log.Fatal(err)
	}
	rows, _ := db.Query("select film, img from films where id = $1", id)
	defer rows.Close()
	for rows.Next() {
		err := rows.Scan(&film, &img)
		if err != nil {
			log.Fatal(err)
		}
	}
	return film, img
}

func UpdateImagePostgre(id int, img string){
	var (
		ctx2 = context.Background()
		dsn  = "user=ozon password=ozon dbname=ozon sslmode=disable"
	)
	db, err1 := sql.Open("postgres", dsn)
	db.SetMaxOpenConns(10)

	if err1 = db.PingContext(ctx2); err1 != nil {
		log.Fatal(err1)
	}
	var res sql.Result
	var err error
	if res, err = db.Exec("UPDATE films SET img = $1 where id = $2", img, id); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%v", res)
}

func UpdateScorePostgre(userid int, username string, score int, inres int) (result int) {
	var (
		ctx2 = context.Background()
		dsn  = "user=ozon password=ozon dbname=ozon sslmode=disable"
	)

	// var score int64
	score = 0
	db, err1 := sql.Open("postgres", dsn)
	db.SetMaxOpenConns(10)

	if err1 = db.PingContext(ctx2); err1 != nil {
		log.Fatal(err1)
	}
	var res sql.Result
	var err error
	if res, err = db.Exec("INSERT INTO results (user_id, user_name, score) values ($1, $2, $3)", userid, username, score); err != nil {
		log.Fatal(err)
	}
	if inres == 10 {
		rows, _ := db.Query("SELECT sum(score) as score FROM public.results where user_id = $1 LIMIT 10", userid)
		defer rows.Close()
		for rows.Next() {
			err := rows.Scan(&result)
			if err != nil {
				log.Fatal(err)
			}
		}
	}
log.Print(res)	
	return result
}
