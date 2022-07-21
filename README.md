# lululemon-stockchecker

Simple stock checker for Lululemon products. Given a product URI, if the status code of the web page is **302**, therefore the product is out of stock.

## Product URI

The product URI can be set using the `LULULEMON_URI` environment variable. A good example would be [something like this](https://shop.lululemon.com/p/bags/New-Crew-Backpack/_/prod9371063?color=45957&sz=ONESIZE).

## Alerts on Slack

Alerts via Slack work when the `SLACK_WEBHOOK_URI` environment variable is set. This variable represents the URI of a Slack Incoming Webhook.