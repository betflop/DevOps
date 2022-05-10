package main

import (
	"context"
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

func main() {
	var (
		ctx = context.Background()
		dsn = "user=ozon password=ozon dbname=ozon sslmode=disable"
	)

	db, err := sql.Open("postgres", dsn)
	if err = db.PingContext(ctx); err != nil {
		log.Fatal(err)
	}

	// var res sql.Result
	// if res, err = db.Exec("insert into accounts (user_id, username, password, email) values ($1, $2, $3, $4)", 11, "pavlyk", "111", "pawwlyk52@gmail.com"); err != nil {
	// 	log.Fatal(err)
	// }
	// fmt.Printf("res = %v\n", res)

	// var usernames []string
	rows, err := db.Query("select username, password from accounts")
	defer rows.Close()
	for rows.Next() {
		// println("next")
		var username string
		var password string
		// println(rows)
		err := rows.Scan(&username, &password)
		if err != nil {
			log.Fatal(err)
		}
		// println("err - ", err)
		println(username, password)
		// IDs = append(IDs, ID)
	}
	err = rows.Err()

	// err = row.Scan(&ID)
	// err = row.Err()
	// if err == sql.ErrNoRows {
	// log.Fatal("Not Found")
	// }
}
