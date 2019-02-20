defmodule NubankAPI.Access do
  defstruct access_token: nil,
            links: %{},
            refresh_before: DateTime.utc_now(),
            refresh_token: nil,
            token_type: "bearer"
end
