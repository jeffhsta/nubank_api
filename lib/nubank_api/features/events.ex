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
  def fetch_events(access = %Access{}) do
    with %{"events" => events} <- @http.get(@link, access) do
      {:ok, Enum.map(events, &parse_event/1)}
    end
  end

  @doc """
  Fetch transactions.

  ## Examples

      iex> NubankAPI.Feature.Events.fetch_transactions(access)
      {:ok, [%NubankAPI.Event{category: :transaction]}}
  """
  def fetch_transactions(access = %Access{}) do
    with {:ok, events} <- fetch_events(access) do
      {:ok, Enum.filter(events, &(&1.category == :transaction))}
    end
  end

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
