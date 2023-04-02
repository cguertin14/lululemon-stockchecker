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