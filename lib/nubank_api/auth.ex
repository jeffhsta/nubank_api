defmodule NubankAPI.Auth do
  alias NubankAPI.Config

  def get_token(login, password) when is_bitstring(login) and is_bitstring(password) do
    with %{url: url, headers: headers, body: body} = prepare_request_data(login, password),
         {:ok, %{body: body}} <- HTTPoison.post(url, body, headers),
         {:ok, parsed_body} <- Poison.decode(body),
         {:ok, data} <- extract_response_data(parsed_body) do
      {:ok, data}
    else
      unmatch_result -> {:error, unmatch_result}
    end
  end

  def get_token(_login, _password), do: {:error, "Login and password must be strings!"}

  defp prepare_request_data(login, password) do
    body =
      Poison.encode!(%{
        login: login,
        password: password,
        grant_type: "password",
        client_id: "other.conta",
        client_secret: "yQPeLzoHuJzlMMSAjC-LgNUJdUecx8XO"
      })

    %{
      url: Config.token_api_uri(),
      headers: Config.default_headers(),
      body: body
    }
  end

  defp extract_response_data(parsed_body) do
    with {:ok, refresh_bofore, 0} <- DateTime.from_iso8601(parsed_body["refresh_before"]) do
      {:ok,
       %{
         access_token: parsed_body["access_token"],
         refresh_before: refresh_bofore,
         token_type: parsed_body["token_type"],
         refresh_token: parsed_body["refresh_token"]
       }}
    end
  end
end
