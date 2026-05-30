import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mailexam, MailexamWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FbTncWAtRLreW3G7u0ZC3+bnTR/P8epGk7Dq7fYPaAXrxqEYNZnMa+I1xvIUW2Q0",
  server: false

# In test we don't send emails
config :mailexam, Mailexam.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true
