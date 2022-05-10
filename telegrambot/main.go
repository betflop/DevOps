package main

import (
	"io/ioutil"
	"log"

	"fmt"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"

	"context"
	"database/sql"

	"gopkg.in/yaml.v2"

	_ "github.com/lib/pq"
)

type Config struct {
	Token    string `yaml:"token"`
	// Database struct {
	// 	Dbname     string
	// 	Dbuser     string
	// 	Dbpassword string
	// }
}

var numericKeyboard = tgbotapi.NewInlineKeyboardMarkup(
    tgbotapi.NewInlineKeyboardRow(
        tgbotapi.NewInlineKeyboardButtonURL("1.com", "http://1.com"),
        tgbotapi.NewInlineKeyboardButtonData("2", "2_correct"),
        tgbotapi.NewInlineKeyboardButtonData("3", "3_error"),
    ),
    tgbotapi.NewInlineKeyboardRow(
        tgbotapi.NewInlineKeyboardButtonData("4", "4"),
        tgbotapi.NewInlineKeyboardButtonData("5", "5"),
        tgbotapi.NewInlineKeyboardButtonData("6", "6"),
    ),
)
func main() {
	var c Config

	yamlFile, err := ioutil.ReadFile("./botconfig.yml")
	if err != nil {
		log.Fatal(err)
		return
	}
	err = yaml.Unmarshal(yamlFile, &c)
	if err != nil {
		log.Fatal(err)
		return
	}
	fmt.Printf("%v\n", c)
	bot, err := tgbotapi.NewBotAPI(c.Token)
	if err != nil {
		log.Panic(err)
	}

	bot.Debug = true

	log.Printf("Authorized on account %s", bot.Self.UserName)

	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60

	updates := bot.GetUpdatesChan(u)

	for update := range updates {
		if update.Message != nil { // If we got a message
			log.Println("connnect --------------")
			log.Printf("[%s] +++ %s", update.Message.From.UserName, update.Message.Text)

			msg := tgbotapi.NewMessage(update.Message.Chat.ID, update.Message.Text)
			msg.ReplyMarkup = numericKeyboard
			// msg.ReplyToMessageID = update.Message.MessageID

			bot.Send(msg)
		} else if update.CallbackQuery != nil {
            // Respond to the callback query, telling Telegram to show the user
            // a message with the data received.
            callback := tgbotapi.NewCallback(update.CallbackQuery.ID, update.CallbackQuery.Data)
            if _, err := bot.Request(callback); err != nil {
                panic(err)
            }

            // And finally, send a message containing the data received.
            msg := tgbotapi.NewMessage(update.CallbackQuery.Message.Chat.ID, update.CallbackQuery.Data)
            if _, err := bot.Send(msg); err != nil {
                panic(err)
            }
	}
}
}

func postgre() {
	var (
		ctx = context.Background()
		dsn = "user=ozon dbname=ozon sslmode=disable"
	)

	db, err := sql.Open("postgres", dsn)
	if err = db.PingContext(ctx); err != nil {
		log.Fatal(err)
	}

	// var res sql.Result
	// if res, err = db.Exec("delete from a where aid = $1", 1); err != nil {
	// 	log.Fatal(err)
	// }
	// count, _ := res.RowsAffected()
	// if count == 0 {
	// 	log.Fatal("Not Found")
	// }

	// var ID int
	// row := db.QueryRow("insert into a (aid) values $1 returning aid", 1)
	// err = row.Scan(&ID)
	// if err == sql.ErrNoRows {
	// 	log.Fatal("Not Found")
	// }

	// var IDs []int
	// rows, err := db.Query("select aid from a")
	// defer rows.Close()
	// for rows.Next() {
	// 	var ID int
	// 	err = rows.Scan(&ID, &ID)
	// 	IDs = append(IDs, ID)
	// }
	// err = rows.Err()
}

