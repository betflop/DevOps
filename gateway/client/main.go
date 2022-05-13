package main

import (
	"context"
	"strconv"
	"strings"

	pb "example.gateway/gen/pb-go/pb"
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
	conn, err := grpc.Dial("0.0.0.0:12201", opts...)

	if err != nil {
		grpclog.Fatalf("fail to dial: %v", err)
	}

	defer conn.Close()

	client := pb.NewGatewayClient(conn)
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
			var num int64
			sendNewQuestions(client, bot, update, botconfig, update.Message.Chat.ID, update.Message.Text, num)
		} else if update.CallbackQuery != nil {
			updateCallback(client, bot, update)

			words := strings.Split(update.CallbackQuery.Data, "_")
			i, _ := strconv.ParseInt(words[0], 10, 64)
			if i < 10 {
				sendNewQuestions(client, bot, update, botconfig, update.CallbackQuery.From.ID, "/start", i)
			}
		}
	}
}

func updateCallback(client pb.GatewayClient, bot *tgbotapi.BotAPI, update tgbotapi.Update) {
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
	var score int64
	words := strings.Split(update.CallbackQuery.Data, "_")
	// for idx, word := range words {
	// 	fmt.Printf("Word %d is: %s\n", idx, word)
	// }
	if words[1] == "correct" {
		text = "Правильно!"
		score = 1
	} else {
		text = "Ошибка..."
		score = 0
	}
	i, _ := strconv.ParseInt(words[0], 10, 64)
	request := &pb.Message{UserId: update.CallbackQuery.From.ID, UserName: update.CallbackQuery.From.UserName, Score: score, Result: i}
	response, _ := client.UpdateScore(context.Background(), request)
	// println("response --------------")
	result := response.Result
	println(result)
	msg := tgbotapi.NewMessage(update.CallbackQuery.Message.Chat.ID, text)
	if _, err := bot.Send(msg); err != nil {
		panic(err)
	}

	if i == 10 {
		msg := tgbotapi.NewMessage(update.CallbackQuery.Message.Chat.ID, "Отлично!\nТвой результат "+strconv.FormatInt(result, 10)+" из 10.\nЕсли хочешь сыграть еще раз, нажми /start")
		if _, err := bot.Send(msg); err != nil {
			panic(err)
		}

	}

}

func sendNewQuestions(client pb.GatewayClient, bot *tgbotapi.BotAPI, update tgbotapi.Update, botconfig Config, ChatID int64, messageText string, num int64) {
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
		i := rand.Intn(65) + 1
		if _, ok := questions[i]; ok {
			//do something here
		} else {
			questions_array = append(questions_array, i)
			var film string
			var img string
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
					request2 := &pb.Message{Id: int64(i), Img: img}
					response2, err := client.UpdateImage(context.Background(), request2)
					println(response2)
					if err != nil {
						grpclog.Fatalf("fail to dial: %v", err)
					}
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
	num++
	numstr := strconv.FormatInt(num, 10)
	// numstr := strconv.Itoa(num)
	var numericKeyboard = tgbotapi.NewInlineKeyboardMarkup(
		tgbotapi.NewInlineKeyboardRow(
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[0]][0], numstr+"_"+questions[questions_array[0]][1]),
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[1]][0], numstr+"_"+questions[questions_array[1]][1]),
		),
		tgbotapi.NewInlineKeyboardRow(
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[2]][0], numstr+"_"+questions[questions_array[2]][1]),
			tgbotapi.NewInlineKeyboardButtonData(questions[questions_array[3]][0], numstr+"_"+questions[questions_array[3]][1]),
		),
	)
	msg := tgbotapi.NewMessage(ChatID, text)
	msg.ParseMode = "markdown"

	if messageText == "/start" {
		msg.ReplyMarkup = numericKeyboard
	}
	msg.ReplyMarkup = numericKeyboard
	bot.Send(msg)
}
