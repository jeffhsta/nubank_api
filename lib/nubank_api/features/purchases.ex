defmodule NubankAPI.Feature.Purchases do
  @moduledoc """
  Module responsible for handling the data from the :purchases endpoint.
  """

  use NubankAPI.Feature
  alias NubankAPI.{Access, Purchase}

  @link :purchases
  @known_categories [
    :lazer,
    :outros,
    :transporte,
    :eletrônicos,
    :restaurante,
    :vestuário,
    :serviços,
    :casa,
    :supermercado,
    :educação,
    :viagem
  ]

  @known_status [
    :settled,
    :unsettled,
    :canceled,
    :expired,
    :reversed
  ]

  @known_event_types [
    :transaction_card_not_present,
    :transaction_card_present
  ]

  @doc """
  Fetches purchases information

  ## Examples

      iex> NubankAPI.Feature.Purchases.fetch_purchases(access)
      {:ok, [%SavingsAccount{}]}

  """
  def fetch_purchases(access = %Access{}, opts \\ []) do
    with {:ok, %{"transactions" => purchases}} <- @http.get(@link, access),
         parsed_purchases <- Enum.map(purchases, &parse_purchase/1) do
      {:ok, parsed_purchases}
    end
  end

  @doc """
  List the known purchase categories

  ## Examples

      iex> NubankAPI.Feature.Purchases.list_known_categories()
      [ :lazer, :outros, :transporte, :eletrônicos, :restaurante, :vestuário, :serviços, :casa, :supermercado, :educação, :viagem ]
  ]
  """
  def list_known_categories, do: @known_categories

  @doc """
  List the known purchase status

  ## Examples

      iex> NubankAPI.Feature.Purchases.list_known_status()
      [ :settled, :unsettled, :canceled, :expired, :reversed ]
  ]
  """
  def list_known_status, do: @known_status

  @doc """
  List the known purchase event types

  ## Examples

      iex> NubankAPI.Feature.Purchases.list_known_categories()
      [ :transaction_card_not_present, :transaction_card_present ]
  """
  def list_known_event_types, do: @known_event_types

  defp parse_purchase(purchase) do
    %Purchase{
      account: purchase["account"],
      acquirer_id: purchase["acquirer_id"],
      amount: purchase["amount"],
      approved_reasons: purchase["approved_reasons"],
      auth_code: purchase["auth_code"],
      capture_mode: purchase["capture_mode"],
      card: purchase["card"],
      category: purchase["category"],
      chargebacks: purchase["chargebacks"],
      charges: purchase["charges"],
      charges_list: purchase["charges_list"],
      country: purchase["country"],
      customer: purchase["customer"],
      event_type: purchase["event_type"],
      id: purchase["id"],
      expires_on: purchase["expires_on"],
      mcc: purchase["mcc"],
      merchant_id: purchase["merchant_id"],
      merchant_name: purchase["merchant_name"],
      original_merchant_name: purchase["original_merchant_name"],
      postcode: purchase["postcode"],
      precise_amount: purchase["precise_amount"],
      recurring: purchase["recurring"],
      secure_code: purchase["secure_code"],
      source: purchase["source"],
      stand_in: purchase["stand_in"],
      status: purchase["status"],
      time: purchase["time"],
      time_wallclock: purchase["time_wallclock"],
      lon: purchase["lon"],
      lat: purchase["lat"],
      tags: purchase["tags"],
      fx: purchase["fx"],
      _links: purchase["_links"]
    }
  end
end
