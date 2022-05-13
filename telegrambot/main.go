package main

import (
	"io/ioutil"
	"log"
	"time"

	"fmt"

	"context"
	"database/sql"
	"math/rand"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"

	"gopkg.in/yaml.v2"

	_ "github.com/lib/pq"
	g "github.com/serpapi/google-search-results-golang"
)

type Config struct {
	Token string `yaml:"token"`
	Api   string `yaml:"api"`
}

func parse(film string, api string) string {
	parameter := map[string]string{
		"q":   "Кадр из фильма " + film,
		"tbm": "isch",
	}

	query := g.NewGoogleSearch(parameter, api)
	// Many search engine available: bing, yahoo, baidu, googemaps, googleproduct, googlescholar, ebay, walmart, youtube..

	rsp, err := query.GetJSON()
	println(err)
	results := rsp["images_results"].([]interface{})
	data := results[0].(map[string]interface{})
	// return data
	if str, ok := data["original"].(string); ok {
		/* act on str */
		return str
	} else {
		/* not string */
		return "error"
	}
}
func main() {
	var botconfig Config
	var (
		ctx = context.Background()
		dsn = "user=ozon password=ozon dbname=ozon sslmode=disable"
	)

	db, err := sql.Open("postgres", dsn)
	if err = db.PingContext(ctx); err != nil {
		log.Fatal(err)
	}

	yamlFile, err := ioutil.ReadFile("./botconfig.yml")
	if err != nil {
		log.Fatal(err)
		return
	}
	err = yaml.Unmarshal(yamlFile, &botconfig)
	if err != nil {
		log.Fatal(err)
		return
	}
	// fmt.Printf("%v\n", c)
	bot, err := tgbotapi.NewBotAPI(botconfig.Token)
	if err != nil {
		log.Panic(err)
	}

	bot.Debug = true

	log.Printf("Authorized on account %s", bot.Self.UserName)

	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60

	updates := bot.GetUpdatesChan(u)

	for update := range updates {

		rand.Seed(time.Now().UnixNano())
		if update.Message != nil { // If we got a message
			sendNewQuestions(bot, db, update, botconfig, update.Message.Chat.ID, update.Message.Text)
		} else if update.CallbackQuery != nil {
			updateCallback(bot, db, update)
			if true {
				sendNewQuestions(bot, db, update, botconfig, update.CallbackQuery.From.ID, "/start")
			}
		}
	}
}

func updateCallback(bot *tgbotapi.BotAPI, db *sql.DB, update tgbotapi.Update) {
	// Respond to the callback query, telling Telegram to show the user
	// a message with the data received.
	callback := tgbotapi.NewCallback(update.CallbackQuery.ID, update.CallbackQuery.Data)
	if _, err := bot.Request(callback); err != nil {
		panic(err)
	}

	ChatID := update.CallbackQuery.Message.Chat.ID
	MessageID := update.CallbackQuery.Message.MessageID
	emptyKeyboard := tgbotapi.InlineKeyboardMarkup{InlineKeyboard: make([][]tgbotapi.InlineKeyboardButton, 0, 0)}
	editedMsg := tgbotapi.NewEditMessageReplyMarkup(ChatID, MessageID, emptyKeyboard)

	bot.Send(editedMsg)
	// And finally, send a message containing the data received.

	var text string
	if update.CallbackQuery.Data == "correct" {
		text = "Правильно!"
	} else {
		text = "Ошибка..."
	}
	msg := tgbotapi.NewMessage(update.CallbackQuery.Message.Chat.ID, text)
	if _, err := bot.Send(msg); err != nil {
		panic(err)
	}
}

func sendNewQuestions(bot *tgbotapi.BotAPI, db *sql.DB, update tgbotapi.Update, botconfig Config, ChatID int64, messageText string) {
	// log.Printf("[%s] +++ %s", update.Message.From.UserName, update.Message.Text)
	var text string
	if messageText != "/start" {
		text = "Привет я бот Угадай кино, нажми на /start"
	} else {
		text = "Угадай кино"
	}

	questions_array := make([]int, 0, 4)
	questions := make(map[int][]string)
	correct_answer := rand.Intn(4) + 1
	for {
		i := rand.Intn(4) + 1
		if _, ok := questions[i]; ok {
			//do something here
			// println("уже было")
		} else {
			questions_array = append(questions_array, i)
			var film string
			var img string
			film, img = findfilm(db, i)
			questions[i] = append(questions[i], film)
			var answer string
			if len(questions) == correct_answer {
				answer = "correct"
				if len(img) == 0 {
					img = parse(questions[i][0], botconfig.Api)
					updateImage(db, i, img)
				}
				text = "[Угадай кино по кадру](" + img + ")"

			} else {
				answer = "error"
			}

			questions[i] = append(questions[i], answer)
		}
		if len(questions) == 4 {
			break
		}
	}
	var numericKeyboard = tgbotapi.NewInlineKeyboardMarkup(
		tgbotapi.NewInlineKeyboardRow(
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[0]][0], questions[questions_array[0]][1]),
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[1]][0], questions[questions_array[1]][1]),
		),
		tgbotapi.NewInlineKeyboardRow(
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[2]][0], questions[questions_array[2]][1]),
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[3]][0], questions[questions_array[3]][1]),
		),
	)
	msg := tgbotapi.NewMessage(ChatID, text)
	msg.ParseMode = "markdown"

	if messageText == "/start" {
		msg.ReplyMarkup = numericKeyboard
	}
	fmt.Printf("questions = %v", questions)
	println("questions_array", questions_array)
	msg.ReplyMarkup = numericKeyboard
	bot.Send(msg)
}

func findfilm(db *sql.DB, id int) (string, string) {
	rows, _ := db.Query("select film, img from films where id = $1", id)
	defer rows.Close()
	var film string
	var img string
	for rows.Next() {
		err := rows.Scan(&film, &img)
		if err != nil {
			log.Fatal(err)
		}
	}
	return film, img
}

func updateImage(db *sql.DB, id int, image string) {
	var res sql.Result
	var err error
	if res, err = db.Exec("UPDATE films SET img = $1 where id = $2", image, id); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%v", res)
}
