defmodule NubankAPI.Feature.BillSummaries do
  @moduledoc """
  Module responsible for handling the data from the :bills_summary endpoint.
  """

  use NubankAPI.Feature
  alias NubankAPI.{Access, BillSummary}

  @link :bills_summary
  @known_states [
    :open,
    :overdue
  ]

  @doc """
  Fetch bill summaries (both open and overdue)

  ## Examples

      iex> NubankAPI.Feature.BillSummaries.fetch_bill_summaries(access)
      {:ok, [%BillSummary{}]}

      iex> NubankAPI.Feature.BillSummaries.fetch_bill_summaries(access, state: :open)
      {:ok, [%BillSummary{state: :open}]}
  """
  def fetch_bill_summaries(access = %Access{}, opts \\ []) do
    state_filter = Keyword.get(opts, :state)

    with {:ok, %{"bills" => bills}} <- @http.get(@link, access),
         parsed_bill_summaries <- Enum.map(bills, &parse_bill_summary/1),
         {:ok, filtered_bill_summaries} <-
           filter_bill_summaries(parsed_bill_summaries, state_filter) do
      {:ok, filtered_bill_summaries}
    end
  end

  @doc """
  List the known bill states

  ## Examples

      iex> NubankAPI.Feature.BillSummaries.list_known_states()
      [:open, :overdue]
  """
  def list_known_states, do: @known_states

  defp filter_bill_summaries(bill_summaries, nil), do: {:ok, bill_summaries}

  defp filter_bill_summaries(bill_summaries, state) when state in @known_states,
    do: {:ok, Enum.filter(bill_summaries, &(&1.state == state))}

  defp filter_bill_summaries(_bill_summaries, _state), do: {:error, "Invalid bill state"}

  defp parse_bill_summary(bill_summary) do
    %BillSummary{
      id: bill_summary["id"],
      state: String.to_atom(bill_summary["state"]),
      summary: bill_summary["summary"]
    }
  end
end
