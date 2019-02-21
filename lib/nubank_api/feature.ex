defmodule NubankAPI.Feature do
  defmacro __using__(_) do
    quote do
      alias NubankAPI.HTTP
    end
  end
end
