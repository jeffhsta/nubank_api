defmodule NubankAPI.Feature.Events do
  @moduledoc """
  Module responsable for handle the data from the :events link.

  This link is avaible in NuBankAPI.Access links as response from NubankAPI.Auth.get_token/2.
  """

  use NubankAPI.Feature
  alias NubankAPI.{Access, Event}

  @link :events

  @doc """
  Fetch transactions.

  ## Examples

      iex> NubankAPI.Feature.Events.fetch_transactions(access)
      {:ok, []}
  """
  def fetch_transactions(access = %Access{}) do
    with %{"events" => transactions} <- @http.get(@link, access) do
      parse_transactions(transactions)
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

    %Event{
      id: transaction["id"],
      description: transaction["description"],
      amount: transaction["amount"],
      time: transaction_datetime,
      title: transaction["title"]
    }
  end
end