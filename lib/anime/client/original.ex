require Anime.Wallpaper.ApiService
require Anime.Wallpaper.ApiGate

defmodule Anime.Client.Original do
  @moduledoc """
  Original module for work with anime functionality (images, etc).
  This client used on dev and prov environments
  """

  @doc """
  Get random image from Reddit
  """
  @spec get_random_image() :: Anime.Wallpaper.ApiGate.Image.t
  def get_random_image do
    Anime.Wallpaper.ApiService.response
    |> Anime.Wallpaper.ApiGate.get
    |> Enum.random
  end
end
