package main

import (
	"context"
	"fmt"

	pb "example.gateway/gen/pb-go/pb"
	// pb "github.com/matzhouse/go-grpc/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/grpclog"

	"io/ioutil"
	"log"
	"time"

	"math/rand"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"

	"gopkg.in/yaml.v2"
)

type Config struct {
	Token string `yaml:"token"`
	Api   string `yaml:"api"`
}

func main() {
	var botconfig Config
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

	opts := []grpc.DialOption{
		grpc.WithInsecure(),
	}
	// args := os.Args
	conn, err := grpc.Dial("0.0.0.0:12201", opts...)

	if err != nil {
		grpclog.Fatalf("fail to dial: %v", err)
	}

	defer conn.Close()

	client := pb.NewGatewayClient(conn)
	// args[1]
	// i, err := strconv.ParseUint(args[1], 10, 64)
	// if err != nil {
	// handle error
	// fmt.Println(err)
	// os.Exit(2)
	// }

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
			sendNewQuestions(client, bot, update, botconfig, update.Message.Chat.ID, update.Message.Text)
		} else if update.CallbackQuery != nil {
			updateCallback(bot, update)
			if true {
				sendNewQuestions(client, bot, update, botconfig, update.CallbackQuery.From.ID, "/start")
			}
		}
	}
}

func updateCallback(bot *tgbotapi.BotAPI, update tgbotapi.Update) {
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

func sendNewQuestions(client pb.GatewayClient, bot *tgbotapi.BotAPI, update tgbotapi.Update, botconfig Config, ChatID int64, messageText string) {
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
			// film, img = findfilm(db, i)

			request := &pb.Message{Id: int64(i)}
			response, err := client.FindFilm(context.Background(), request)
			println("response --------------")
			film = response.Film
			img = response.Img
			if err != nil {
				grpclog.Fatalf("fail to dial: %v", err)
			}
			questions[i] = append(questions[i], film)
			var answer string
			if len(questions) == correct_answer {
				answer = "correct"
				if len(img) == 0 {

					request1 := &pb.Message{Film: questions[i][0], Api: botconfig.Api}
					response1, err := client.GetImage(context.Background(), request1)
					img = response1.Img
					if err != nil {
						grpclog.Fatalf("fail to dial: %v", err)
					}
					// img = parse(questions[i][0], botconfig.Api)
					request2 := &pb.Message{Id: int64(i), Img: img}
					response2, err := client.UpdateImage(context.Background(), request2)
					// img = response.Img
					println(response2)
					if err != nil {
						grpclog.Fatalf("fail to dial: %v", err)
					}
					// updateImage(db, i, img)
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
