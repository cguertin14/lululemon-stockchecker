package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

func main() {
	uri := os.Getenv("LULULEMON_URI")
	res, err := http.Get(uri)
	if err != nil {
		if !strings.Contains(err.Error(), "stopped after") {
			log.Fatalf("failed to perform GET request: %s", err)
		}
	}

	isInStock := res.StatusCode != http.StatusFound
	if err = slackWebhook(isInStock, uri); err != nil {
		log.Fatalf("failed to inform slack: %s", err)
	}
}

func slackWebhook(isInStock bool, uri string) error {
	slackWebhookUri := os.Getenv("SLACK_WEBHOOK_URI")
	values := map[string]string{"text": fmt.Sprintf("The product %s is **in stock**.", uri)}
	if !isInStock {
		values["text"] = fmt.Sprintf("The product %s is **out of stock**.", uri)
	}

	data, err := json.Marshal(values)
	if err != nil {
		return err
	}

	_, err = http.Post(slackWebhookUri, "application/json", bytes.NewBuffer(data))
	if err != nil {
		return err
	}

	return nil
}
