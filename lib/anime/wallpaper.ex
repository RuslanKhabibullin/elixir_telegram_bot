require Anime.Wallpaper.ApiService
require Anime.Wallpaper.ApiGate

defmodule Anime.Wallpaper do
  def get_random_image do
    Anime.Wallpaper.ApiService.response
    |> Anime.Wallpaper.ApiGate.get
    |> Enum.random
  end
end
