defmodule NubankAPI do
  @moduledoc """
  NubankAPI is the main module.
  """

  alias NubankAPI.Config

  @doc """
  Library status

  ## Examples

      iex> NubankAPI.transactions(access)
      {:ok, []}

  """

  # TODO: check the endpoint for fetch transactions
  def transactions(%{access_token: token, links: %{some_endpoint: url}}) do
    headers = Config.default_headers() ++ [{"Authorization", "Bearer #{token}"}]

    with {:ok, %{body: body}} <- HTTPoison.get(url, headers),
         {:ok, parsed_body} <- Poison.decode(body),
         %{"events" => transactions} <- parsed_body,
         {:ok, parsed_transactions} <- parse_transactions(transactions) do
      {:ok, parsed_transactions}
    else
      unmatch_result -> {:error, unmatch_result}
    end
  end

  defp parse_transactions(transactions) do
    parsed_transactions =
      transactions
      |> Enum.filter(fn %{"category" => category} -> category == "transaction" end)
      |> Enum.map(&parse_single_transaction/1)

    {:ok, parsed_transactions}
  end

  defp parse_single_transaction(transaction) do
    {:ok, transaction_datetime, 0} = DateTime.from_iso8601(transaction["time"])
    %{
      id: transaction["id"],
      description: transaction["description"],
      amount: transaction["amount"],
      time: transaction_datetime,
      title: transaction["title"]
    }
  end
end
