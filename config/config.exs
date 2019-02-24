use Mix.Config

if Mix.env() == :test do
  config :nubank_api, http: NubankAPI.Mock.HTTP
end
