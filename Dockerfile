FROM elixir:1.19-otp-29-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile

COPY . .
RUN mix compile

ENV MIX_ENV=dev
ENV PORT=4000

EXPOSE 4000

CMD ["mix", "phx.server"]
