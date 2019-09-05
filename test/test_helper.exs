ExUnit.start()

Mox.defmock(TelegramClientMock, for: Telegram.ClientBehaviour)
Mox.defmock(AnimeClientMock, for: Anime.ClientBehaviour)
Mox.defmock(HTTPClientMock, for: Fetch.ClientBehaviour)
