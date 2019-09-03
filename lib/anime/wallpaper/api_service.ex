defmodule Anime.Wallpaper.ApiService do
  @moduledoc """
  Module make HTTP requests for Reddit images and returns response
  """

  @doc """
  Make HTTP request to `https://www.reddit.com/r/Animewallpaper/new/.json?sort=new&limit=50` and returns parsed result
  """
  @spec response() :: {:ok, map()}
  def response do
    case HTTPoison.get("https://www.reddit.com/r/Animewallpaper/new/.json?sort=new&limit=50") do
      {:ok, response} -> parse(response)
      {:error, _} -> raise "Cant fetch anime wallpapers"
    end
  end

  defp parse(%{status_code: 200, body: json_body}) do
    Poison.Parser.parse(json_body)
  end

  defp parse(%{status_code: status}) do
    raise "Cant fetch anime wallpapers: #{status}"
  end
end
