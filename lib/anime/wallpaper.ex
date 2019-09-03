require Anime.Wallpaper.ApiService
require Anime.Wallpaper.ApiGate

defmodule Anime.Wallpaper do
  @moduledoc """
  Module for work with anime functionality (images, etc)
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
