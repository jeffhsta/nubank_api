defmodule NubankAPI.Feature do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias NubankAPI.HTTP
    end
  end
end
