defmodule Anime.Wallpaper.ApiGateTest do
  use ExUnit.Case

  doctest Anime.Wallpaper.ApiGate

  alias Anime.Wallpaper.ApiGate.Image
  alias Anime.Wallpaper.ApiGate
  alias Anime.Wallpaper.ApiGate.ParseError

  describe "get/1" do
    test "called with valid arguments" do
      arguments = {:ok, %{
        "data" => %{
          "children"=>[
            %{"data" => %{"url" => "http://www.google.com", "id" => 1, "created_utc" => 0}},
            %{"data" => %{"url" => "http://www.google.com/image.png", "id" => 2, "created_utc" => 1}}
          ]
        }
      }}
      
      assert ApiGate.get(arguments) == [%Image{url: "http://www.google.com/image.png", id: 2, created_utc: 1}]
    end

    test "server responds with invalid response" do
      assert_raise ParseError, fn -> ApiGate.get({:error, %{}}) end
    end
  end
end
