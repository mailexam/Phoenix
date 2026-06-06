# Phoenix + Mailexam

Minimal [Phoenix](https://www.phoenixframework.org/) example that sends test mail through [Mailexam](https://mailexam.ru/) SMTP via [Swoosh](https://hexdocs.pm/swoosh/).

Based on the [Mailexam Phoenix guide](https://wiki.mailexam.ru/en/examples/phoenix/).

## What you need

- A Mailexam account and a project with SMTP credentials.
- Elixir 1.15+ and Erlang/OTP 26+.

From your Mailexam welcome email or dashboard:

| Variable | Description |
|----------|-------------|
| `MAILEXAM_LOGIN` | SMTP login (for example, `xxxxx`) |
| `MAILEXAM_PASSWORD` | SMTP password (paired with the login) |
| Host | `{MAILEXAM_LOGIN}.mailexam.ru` (built in `config/runtime.exs`) |

## Quick start (host)

1. Install dependencies:

```bash
mix deps.get
```

2. Export Mailexam credentials (or copy from the example file):

```bash
cp .env.example .env
export $(grep -v '^#' .env | xargs)
```

3. Edit `.env` if needed:

```env
MAILEXAM_LOGIN=YOUR_LOGIN
MAILEXAM_PASSWORD=YOUR_PASSWORD
MAILEXAM_PORT=587
MAIL_FROM=noreply@example.test
```

4. Run the server:

```bash
mix phx.server
```

The server listens on `http://127.0.0.1:4000` by default.

5. Send a test message:

```bash
curl -X POST http://127.0.0.1:4000/mail/test \
  -H 'Content-Type: application/json' \
  -d '{"to":"user@example.test","subject":"Test","body":"Hello"}'
```

The message appears in the Mailexam dashboard → your project → inbox.

### IEx alternative

```bash
iex -S mix
```

```elixir
Mailexam.TestEmail.deliver("user@example.test", "Phoenix + Mailexam", "Mailexam test from Phoenix")
```

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MAILEXAM_LOGIN` | yes | — | SMTP login; also used to build the host name |
| `MAILEXAM_PASSWORD` | yes | — | SMTP password |
| `MAILEXAM_PORT` | no | `587` | SMTP port (`587`, `2525`, or `25`) |
| `MAIL_FROM` | no | `noreply@example.test` | Sender address (any test address is fine) |
| `PORT` | no | `4000` | HTTP listen port |

For ports **587** and **2525**, STARTTLS is enabled (`tls: :always`). For port **25**, it is disabled.

## Project layout

```
.
├── mix.exs
├── config/runtime.exs              # Mailexam SMTP via Swoosh.Adapters.SMTP
├── lib/mailexam/mailer.ex
├── lib/mailexam/test_email.ex
├── lib/mailexam_web/controllers/mail_controller.ex
├── config/routes via router.ex     # POST /mail/test
├── .env.example
├── Dockerfile                      # for local debugging only
└── docker-compose.yml
```

## Docker (debugging)

Docker is provided for local debugging. For day-to-day development, run the app on the host with `mix phx.server` (see above).

```bash
cp .env.example .env
# edit .env with your credentials

docker compose up --build
```

Then call the same endpoint on the mapped port:

```bash
curl -X POST http://127.0.0.1:4000/mail/test \
  -H 'Content-Type: application/json' \
  -d '{"to":"user@example.test","subject":"Test","body":"Hello"}'
```

Inside the container the server binds to `0.0.0.0:4000`.

## CI

Set these secrets in your CI environment:

```yaml
variables:
  MAILEXAM_LOGIN: $MAILEXAM_LOGIN
  MAILEXAM_PASSWORD: $MAILEXAM_PASSWORD
  MAILEXAM_PORT: "587"
  MAIL_FROM: "noreply@example.test"
```

After sending a message in a test, verify delivery via the [Mailexam API](https://mailexam.ru/api).

## Troubleshooting

**TLS or authentication failed**

- Host must be `{login}.mailexam.ru`, where `{login}` matches `MAILEXAM_LOGIN`.
- Login and password must come from the same Mailexam project.

**Port 587**

- Requires `tls: :always`, not `:never`.

**SMTP timeout or `:smtp_response` error**

- Ensure `gen_smtp` is in dependencies and variables are set before `mix phx.server`.

**Message not in the dashboard**

- Open the inbox of the same Mailexam project.
- In dev, enable debug logs: `config :logger, level: :debug`.

## See also

- [Mailexam Phoenix guide (wiki)](https://wiki.mailexam.ru/en/examples/phoenix/)
- [Django reference implementation](https://github.com/mailexam/Django) — similar SMTP configuration via config
- [Swoosh SMTP adapter](https://hexdocs.pm/swoosh/Swoosh.Adapters.SMTP.html)
- [Mailexam API documentation](https://mailexam.ru/api)
