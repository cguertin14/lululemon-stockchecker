package main

import (
	"fmt"
	"log"
	"os"

	"github.com/cguertin14/lululemon-stockchecker/pkg/browser"
	"github.com/cguertin14/lululemon-stockchecker/pkg/http"
	"github.com/cguertin14/lululemon-stockchecker/pkg/slack"
	"github.com/cguertin14/lululemon-stockchecker/pkg/sms"
)

func main() {
	uri := os.Getenv("LULULEMON_URI")
	statusPassed := true
	contentPassed := true

	// 1. Verify status code
	statusPassed, err := http.VerifyPageStatusCode(uri)
	if err != nil {
		log.Fatalf("failed to verify status code: %s", err)
	}

	// 2. Verify page content
	if statusPassed {
		contentPassed, err = browser.VerifyPageContent(uri)
		if err != nil {
			log.Fatalf("failed to verify page content: %s", err)
		}
	}

	// 3. Send alert to Slack
	if err = slack.PerformWebhook(statusPassed && contentPassed, uri); err != nil {
		log.Fatalf("failed to inform slack: %s", err)
	}

	// 4. Send text message if product is in stock
	if statusPassed && contentPassed {
		if err := sms.SendMessage(
			fmt.Sprintf("The product %s is *in stock*, hurry up! 👀👀👀", uri),
		); err != nil {
			log.Fatalf("failed to send sms: %s", err)
		}
	}
}
