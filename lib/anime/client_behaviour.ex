require Anime.Wallpaper.ApiGate

defmodule Anime.ClientBehaviour do
  @moduledoc """
  Defines interface for Anime Client
  """

  @callback get_random_image() :: Anime.Wallpaper.ApiGate.Image.t
end
