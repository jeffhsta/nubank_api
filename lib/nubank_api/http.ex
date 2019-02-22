defmodule NubankAPI.HTTP do
  @moduledoc """
  Behaviour module
  """

  @type link :: atom
  @type access :: NubankAPI.Access.t()
  @type body :: Map.t()
  @type response_body :: Map.t()

  @callback get(link, access) :: {:ok, response_body} | {:error, any}
  @callback post(link, access, body) :: {:ok, response_body} | {:error, any}
end
