defmodule TelegramBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :telegram_bot,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:nadia],
      registered: [:telegram_bot],
      extra_applications: [:logger, :plug_cowboy],
      mod: {TelegramBot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nadia, "~> 0.5.0"},
      {:httpoison, "~> 1.5"},
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:dialyxir, "~> 1.0.0-rc.6", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
