defmodule NubankAPI.HTTPWrapper do
  @moduledoc """
  Wrappers the HTTP requests in order to set properly the default headers, the access token,
  encode and decode JSON payloads and access the link inside the NubankAPI.Access links.
  """

  @behaviour NubankAPI.HTTP

  alias NubankAPI.{Access, Config}

  @impl NubankAPI.HTTP
  def get(link, access = %Access{}) when is_atom(link), do: request(:get, link, access, "")

  @impl NubankAPI.HTTP
  def post(link, access = %Access{}, body) when is_atom(link) and is_map(body) do
    encoded_body = Poison.encode!(body)
    request(:post, link, access, encoded_body)
  end

  defp request(http_method, link, access = %Access{}, encoded_body) do
    %{links: links, access_token: token, token_type: type} = access

    headers =
      Config.default_headers() ++ [{"Authorization", "#{String.capitalize(type)} #{token}"}]

    url = links[link]
    response = HTTPoison.request(http_method, url, encoded_body, headers)

    with {:ok, %{status_code: status_code, body: body}} <- response,
         :ok <- check_status_code(status_code) do
      Poison.decode(body)
    end
  end

  defp check_status_code(status_code) when status_code in 200..299, do: :ok

  defp check_status_code(status_code),
    do: {:error, "Expected status code be in range 200 and 299, but got #{status_code} instead"}
end
