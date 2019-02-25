defmodule NubankAPI.Feature.Events do
  @moduledoc """
  Module responsable for handle the data from the :events link.

  This link is avaible in NuBankAPI.Access links as response from NubankAPI.Auth.get_token/2.
  """

  use NubankAPI.Feature
  alias NubankAPI.{Access, Event}

  @link :events
  @known_categories [
    :account_limit_set,
    :anticipate_event,
    :bill_flow_on_due_date,
    :bill_flow_paid,
    :card_activated,
    :customer_device_authorized,
    :customer_invitations_changed,
    :due_day_changed,
    :earn_offer,
    :initial_account_limit,
    :payment,
    :rewards_canceled,
    :rewards_fee,
    :rewards_redemption,
    :rewards_signup,
    :transaction,
    :transaction_reversed,
    :tutorial,
    :virtual_card_encouragement,
    :welcome
  ]

  @doc """
  Fetch events from all categories.

  ## Examples

      iex> NubankAPI.Feature.Events.fetch_events(access)
      {:ok, [%NubankAPI.Event{}]}
  """
  def fetch_events(access = %Access{}, opts \\ []) do
    category_filter = Keyword.get(opts, :category)

    with {:ok, %{"events" => events}} <- @http.get(@link, access),
         parsed_events <- Enum.map(events, &parse_event/1),
         {:ok, filtered_events} <- filter_events(parsed_events, category_filter) do
      {:ok, filtered_events}
    end
  end

  @doc """
  List the known events categories

  ## Examples

      iex> NubankAPI.Feature.Events.list_known_categories()
      [:transaction, :payment, ...]
  """
  def list_known_categories, do: @known_categories

  defp filter_events(events, nil), do: {:ok, events}

  defp filter_events(events, category) when category in @known_categories,
    do: {:ok, Enum.filter(events, &(&1.category == category))}

  defp filter_events(_events, _category), do: {:error, "Invalid category"}

  defp parse_event(event) do
    {:ok, event_datetime, 0} = DateTime.from_iso8601(event["time"])

    %Event{
      id: event["id"],
      description: event["description"],
      amount: event["amount"],
      time: event_datetime,
      title: event["title"],
      category: String.to_atom(event["category"])
    }
  end
end
