defmodule Anime.Wallpaper.ApiServiceTest do
  use ExUnit.Case

  doctest Anime.Wallpaper.ApiService

  alias Anime.Wallpaper.ApiService.FetchError
  alias Anime.Wallpaper.ApiService

  import Mox

  setup :verify_on_exit!
  setup do
    {:ok, url: "https://www.reddit.com/r/Animewallpaper/new/.json?sort=new&limit=50"}
  end

  describe "response/0" do
    test "server responds with valid response", context do
      expected_response = {:ok, %{
        body: "{\"url\": \"http://www.google.com/image.png\", \"id\":\"233\", \"created_utc\": \"0\"}",
        status_code: 200
      }}

      url = context[:url]
      expect(HTTPClientMock, :get, fn (^url, [], []) -> expected_response end)
      
      assert ApiService.response == {:ok, %{
        "created_utc" => "0",
        "id" => "233",
        "url" => "http://www.google.com/image.png"
      }}
    end

    test "server responds with invalid response", context do
      url = context[:url]
      expect(HTTPClientMock, :get, fn (^url, [], []) -> {:error, %{}} end)
      
      assert_raise FetchError, fn -> ApiService.response end
    end

    test "server respond with valid not 200 response", context do
      url = context[:url]
      expect(HTTPClientMock, :get, fn (^url, [], []) -> {:ok, %{status_code: 500}} end)

      assert_raise FetchError, fn -> ApiService.response end
    end
  end
end
