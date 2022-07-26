# Kubernetes Manifests

Here reside kubernetes manifests to use lululemon-stockchecker in your cluster. 
Since `lululemon-stockchecker` is not web service/microservice but rather a job in itself, it is defined here as a cronjob that runs `hourly`.

## Slack Webhook URI Secret

You may notice that inside the `lululemon-stockchecker-cron` cronjob, it reads a secret called `slack-webhook-uri`, but we don't define it.
That's because you'll have to define it and create it in your cluster before creating the cronjob, like so (make sure to replace the actual webhook uri value by yours):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: slack-webhook-uri
  namespace: lululemon-stockchecker
type: Opaque
data:
  SLACK_WEBHOOK_URI: <YOUR_SLACK_WEBHOOK_URI_HERE>
```

## Twilio Settings Secret

To be able to send Text Messages using the Twilio API, you will have to create a new secret called `twilio-settings`, which will be consumed by the `lululemon-stockchecker-cron` cronjob. It will look like this:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: twilio-settings
  namespace: lululemon-stockchecker
type: Opaque
data:
  SMS_SENDER_PHONE_NUM: <YOUR_SENDER_PHONE_NUM_HERE>
  SMS_RECIPIENT_PHONE_NUM: <YOUR_RECIPIENT_PHONE_NUM_HERE>
  TWILIO_ACCOUNT_SID: <YOUR_TWILIO_ACCOUNT_SID_HERE>
  TWILIO_AUTH_TOKEN: <YOUR_TWILIO_AUTH_TOKEN_HERE>
```