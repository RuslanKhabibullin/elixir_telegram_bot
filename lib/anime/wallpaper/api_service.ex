defmodule Anime.Wallpaper.ApiService do
  @moduledoc """
  Module make HTTP requests for Reddit images and returns response
  """

  defmodule FetchError do
    @moduledoc """
    Custom exception for Reddit api call when we cant get success response
    """

    defexception message: "Can't fetch anime wallpapers"
  end

  @doc """
  Make HTTP request to `https://www.reddit.com/r/Animewallpaper/new/.json?sort=new&limit=50` and returns parsed result
  """
  @spec response() :: {:ok, map()}
  def response do
    case HTTPoison.get("https://www.reddit.com/r/Animewallpaper/new/.json?sort=new&limit=50") do
      {:ok, response} -> parse(response)
      {:error, _} -> raise FetchError
    end
  end

  defp parse(%{status_code: 200, body: json_body}) do
    Poison.Parser.parse(json_body)
  end

  defp parse(_), do: raise FetchError
end
