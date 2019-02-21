defmodule NubankAPI.HTTP do
  @moduledoc """
  Wrappers the HTTP requests in order to set properly the default headers, the access token,
  encode and decode JSON payloads and access the link inside the NubankAPI.Access links.
  """

  alias NubankAPI.{Access, Config}

  @type link :: atom
  @type access :: Access.t()
  @type body :: Map.t()
  @type response_body :: Map.t()

  @spec get(link, access) :: {:ok, response_body} | {:error, any}
  def get(link, access = %Access{}) when is_atom(link), do: request(:get, link, access, "")

  @spec post(link, access, body) :: {:ok, response_body} | {:error, any}
  def post(link, access = %Access{}, body) when is_atom(link) and is_map(body) do
    encoded_body = Poison.encode!(body)
    request(:post, link, access, encoded_body)
  end

  defp request(http_method, link, %{links: links, access_token: token}, encoded_body) do
    headers = Config.default_headers() ++ [{"Authorization", "Bearer #{token}"}]
    url = links[link]
    response = HTTPoison.request(http_method, url, encoded_body, headers)

    with {:ok, %{status_code: status_code, body: body}} <- response,
         :ok <- check_status_code(status_code),
         {:ok, parsed_body} <- Poison.decode(body) do
      {:ok, parsed_body}
    else
      unmatch_result -> {:error, unmatch_result}
    end
  end

  defp check_status_code(status_code) when status_code in 200..299, do: :ok

  defp check_status_code(status_code),
    do: {:error, "Expected status code be in 200 and 299, but got #{status_code} instead"}
end
