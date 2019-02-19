defmodule NubankAPI.Auth do
  @moduledoc """
  NubankAPI.Auth is responsable for handle authentication.

  It has a login function that authenticates the user, getting the access token, it's
  expiration datetime and the refresh token, as well the link for other API features.

  Future implementation will be create the refresh token function.
  """

  alias NubankAPI.Config

  @doc """
  Get auth token.

  It will return a Map with with the structure:
  %{
    access_token: "access token in string",
    links: %{},
    refresh_before: "an expiration DateTime in UTC",
    refresh_token: "refresh token in string"
    token_type: "bearer"
  }

  ## Examples

      iex> NubankAPI.transactions(access)
      {:ok, []}

  """
  def get_token(login, password) when is_bitstring(login) and is_bitstring(password) do
    with %{url: url, headers: headers, body: body} = prepare_request_data(login, password),
         {:ok, %{status_code: status_code, body: body}} <- HTTPoison.post(url, body, headers),
         :ok <- check_status_code(status_code),
         {:ok, parsed_body} <- Poison.decode(body),
         {:ok, data} <- extract_response_data(parsed_body) do
      {:ok, data}
    else
      unmatch_result -> {:error, unmatch_result}
    end
  end

  def get_token(_login, _password), do: {:error, "Login and password must be strings!"}

  defp check_status_code(status) when status in 200..299, do: :ok

  defp check_status_code(status),
    do: {:error, "Expected status code be a range in 200 and 299, but instead it is #{status}"}

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
         refresh_token: parsed_body["refresh_token"],
         links: parse_api_links(parsed_body)
       }}
    end
  end

  defp parse_api_links(%{"_links" => links}) do
    links
    |> Map.keys()
    |> Enum.reduce(%{}, fn link_key, indexed_links ->
      Map.put(indexed_links, String.to_atom(link_key), links[link_key]["href"])
    end)
  end
end
