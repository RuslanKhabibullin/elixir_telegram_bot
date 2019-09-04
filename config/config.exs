use Mix.Config

config :telegram_bot, bot_name: "TestRuslanBot"
config :telegram_bot, server_port: System.get_env("PORT", "8085")
config :telegram_bot, telegram_client: Nadia
config :nadia, token: System.get_env("TELEGRAM_TOKEN", "TEST")

import_config "#{Mix.env}.exs"
