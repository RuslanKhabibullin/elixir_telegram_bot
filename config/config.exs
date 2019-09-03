use Mix.Config

config :telegram_bot, bot_name: "TestRuslanBot"
config :nadia, token: System.get_env("TELEGRAM_TOKEN", "TEST")
