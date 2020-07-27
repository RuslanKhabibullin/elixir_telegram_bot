defmodule Telegram.MessageHandlerBehaviour do
  @moduledoc """
  Defines interface for Telegram MessageHandler
  """

  @typep chat_params :: %{required(:id) => integer}
  @typep message :: %{required(:text) => String.t, required(:chat) => chat_params} 
  @typep params :: %{required(:message) => message}

  @callback call(params) :: true
  @callback call(any) :: nil
end
