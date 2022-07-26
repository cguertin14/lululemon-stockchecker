package sms

import (
	"log"
	"os"

	"github.com/twilio/twilio-go"
	openapi "github.com/twilio/twilio-go/rest/api/v2010"
)

func SendMessage(message string) error {
	// TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN are automatically
	// retrieved from the environment variabls
	client := twilio.NewRestClient()

	// Phone numbers env variables
	sender := os.Getenv("SMS_SENDER_PHONE_NUM")
	recipient := os.Getenv("SMS_RECIPIENT_PHONE_NUM")

	// Send text message
	resp, err := client.Api.CreateMessage(&openapi.CreateMessageParams{
		Body: &message,
		From: &sender,
		To:   &recipient,
	})
	if err != nil {
		return err
	}

	// log message SID
	log.Printf("Twilio Message SID: %q\n", *resp.Sid)

	return nil
}
