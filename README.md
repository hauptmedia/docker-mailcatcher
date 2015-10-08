# docker-mailcatcher

This docker container can be use to receive emails via SMTP and route all incoming SMTP traffic to a single Mailbox which can be accessed via IMAP

## Example Run

```bash
docker run -d -p 25:25 -e MAILCATCHER_USERNAME=mailcatcher -e MAILCATCHER_PASSWORD=mailcatcher hauptmedia/mailcatcher
```

