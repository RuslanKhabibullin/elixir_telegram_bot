use Mix.Config

config :telegram_bot, bot_name: "TestRuslanBot"
config :telegram_bot, server_port: System.get_env("PORT", "8085")
config :nadia, token: System.get_env("TELEGRAM_TOKEN", "TEST")
