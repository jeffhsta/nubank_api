defmodule NubankAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :nubank_api,
      version: "1.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:httpoison, "~> 1.5"},
      {:poison, "~> 4.0"}
    ]
  end

  defp description, do: "Nubank API client implementation"

  defp package do
    [
      maintainers: ["Jefferson Stachelski"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jeffhsta/nubank_api"}
    ]
  end
end
