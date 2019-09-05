require Anime.ClientBehaviour

defmodule Anime.Client do
  @moduledoc """
  Realize anime client interface. Wrapper for different anime clients
  """

  @behaviour Anime.ClientBehaviour

  @anime_client Application.get_env(:telegram_bot, :anime_client)

  @spec get_random_image() :: Anime.Wallpaper.ApiGate.Image.t
  def get_random_image(), do: @anime_client.get_random_image()
end
