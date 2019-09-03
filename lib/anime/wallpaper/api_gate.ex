defmodule Anime.Wallpaper.ApiGate do
  defmodule Image do
    defstruct url: nil, id: 0, created_utc: 0
  end

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
