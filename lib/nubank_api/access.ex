defmodule NubankAPI.Access do
  @moduledoc """
  It's a struct to wrap the information that came from the authentication logic.

  In this struct includes the API access token, the it's type, it's expiration time and
  the refresh token, also there are a list of links which correspond the the available
  endpoints from thr Nubank API.
  """

  defstruct access_token: nil,
            links: %{},
            refresh_before: DateTime.utc_now(),
            refresh_token: nil,
            token_type: "bearer"
end
