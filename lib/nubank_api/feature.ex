defmodule NubankAPI.Feature do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @http Application.get_env(:nubank_api, :http, NubankAPI.HTTPWrapper)
    end
  end
end
