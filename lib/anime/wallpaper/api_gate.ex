defmodule Anime.Wallpaper.ApiGate do
  @moduledoc """
  Module parse response from `Api::Wallpaper::ApiService`
  """

  defmodule Image do
    @typedoc """
    Image type for necessary image data from Reddit response
    """

    @type t :: %__MODULE__{
      url: String.t,
      id: integer,
      created_utc: integer
    }
  
    defstruct url: nil, id: 0, created_utc: 0
  end

  defmodule ParseError do
    @moduledoc """
    Custom exception for Response parse - called when we cant successfully parse response
    """

    defexception message: "Can't parse response"
  end

  @doc """
  Receives response from `Api::Wallpaper::ApiService` and returns parsed and filtered(only images) posts
  """
  @spec get({:ok, map()}) :: list(Anime.Wallpaper.ApiGate.Image.t)
  def get({:ok, %{"data" => %{"children" => children}}}) do
    children
    |> Enum.map(&parse_post/1)
    |> Enum.filter(&is_image?/1)
  end

  def get(_), do: raise ParseError

  defp parse_post(%{"data" => %{"url" => url, "id" => id, "created_utc" => created_utc}}) do
    %Image{url: url, id: id, created_utc: created_utc}
  end

  defp is_image?(%Image{url: url}) do
    url
    |> String.downcase
    |> String.ends_with?(["jpeg", "jpg", "png"])
  end
end
