# lululemon-stockchecker

Simple stock checker for Lululemon products. Given a product URI, if the status code of the web page is **200** and the page doesn't mention **Sold out online**, then the product is in stock.

## Product URI

The product URI can be set using the `LULULEMON_URI` environment variable. A good example would be [something like this](https://shop.lululemon.com/p/bags/New-Crew-Backpack/_/prod9371063?color=45957&sz=ONESIZE).

## Alerts on Slack

Alerts via Slack work when the `SLACK_WEBHOOK_URI` environment variable is set. This variable represents the URI of a Slack Incoming Webhook.

## Alerts via SMS

Alerts via SMS are sent when a product is **in stock** only, using [Twilio's Go SDK](https://www.twilio.com/docs/libraries/go). The following environment variables must be set for the SDK to work properly:

* `SMS_SENDER_PHONE_NUM` -> your twilio phone number
* `SMS_RECIPIENT_PHONE_NUM` -> the phone number you want the sms to be sent to
* `TWILIO_ACCOUNT_SID` -> your twilio accound sid
* `TWILIO_AUTH_TOKEN` -> your twilio auth token