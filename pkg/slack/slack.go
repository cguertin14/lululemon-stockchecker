package slack

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
)

type textPayload struct {
	Type string `json:"type"`
	Text string `json:"text"`
}

type blockPayload struct {
	Text textPayload `json:"text"`
	Type string      `json:"type"`
}

type slackPayload struct {
	Blocks []blockPayload `json:"blocks"`
}

func PerformWebhook(isInStock bool, uri string) error {
	slackWebhookUri := os.Getenv("SLACK_WEBHOOK_URI")
	values := slackPayload{
		Blocks: []blockPayload{
			{
				Type: "section",
				Text: textPayload{
					Type: "mrkdwn",
					Text: fmt.Sprintf("The product %s is *in stock* :eyes::eyes::eyes:", uri),
				},
			},
		},
	}
	if !isInStock {
		values.Blocks[0].Text.Text = fmt.Sprintf("The product %s is *out-of-stock* :cry:", uri)
	}

	data, err := json.Marshal(values)
	if err != nil {
		return err
	}

	res, err := http.Post(slackWebhookUri, "application/json", bytes.NewBuffer(data))
	if err != nil {
		return err
	}
	if res.StatusCode == http.StatusNotFound {
		return errors.New("slack webhook link return a 404 status code, please change it")
	}
	defer res.Body.Close()

	// Print alert to stdout
	fmt.Println(values.Blocks[0].Text.Text)

	return nil
}
