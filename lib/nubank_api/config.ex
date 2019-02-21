defmodule NubankAPI.Config do
  @moduledoc """
  This configuration module is responsable for load the essential information from
  the configurations and set a default value for the missing configurations.
  """

  @default_token_api_uri "https://prod-s0-webapp-proxy.nubank.com.br/api/proxy/AJxL5LBUC2Tx4PB-W6VD1SEIOd2xp14EDQ.aHR0cHM6Ly9wcm9kLWdsb2JhbC1hdXRoLm51YmFuay5jb20uYnIvYXBpL3Rva2Vu"

  def default_headers do
    [
      {"Content-Type", "application/json"},
      {"X-Correlation-Id", "WEB-APP.jO4x1"},
      {"User-Agent",
       "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"},
      {"Origin", "https://conta.nubank.com.br"},
      {"Referer", "https://conta.nubank.com.br/"}
    ]
  end

  def token_api_uri,
    do: Application.get_env(:nubank_api, :token_api_uri) || @default_token_api_uri
end
