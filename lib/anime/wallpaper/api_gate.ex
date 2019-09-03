defmodule Anime.Wallpaper.ApiGate do
  @moduledoc """
  Module parse response from `Api::Wallpaper::ApiService`
  """

  defmodule Image do
    @moduledoc """
    Image struct for necessary image data store from Reddit response
    """

    @type t :: %__MODULE__{
      url: String.t,
      id: integer,
      created_utc: integer
    }
  
    defstruct url: nil, id: 0, created_utc: 0
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

  def get(_) do
    raise "Got unexpected error"
  end

  defp parse_post(%{"data" => %{"url" => url, "id" => id, "created_utc" => created_utc}}) do
    %Image{url: url, id: id, created_utc: created_utc}
  end

  defp is_image?(%Image{url: url}) do
    url
    |> String.downcase
    |> String.ends_with?(["jpeg", "jpg", "png"])
  end
end
