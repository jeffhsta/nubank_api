defmodule NubankAPI.Feature.PurchasesTest do
  use ExUnit.Case, async: true
  import Mox

  alias NubankAPI.{Access, Purchase}
  alias NubankAPI.Feature.Purchases
  alias NubankAPI.Mock.HTTP

  setup do
    purchases_fixture = NubankAPI.TestHelper.load_fixture(:purchases)

    access = %Access{
      access_token: "fake_access_token",
      refresh_before: DateTime.utc_now(),
      refresh_token: "fake_refresh_token",
      token_type: "bearer",
      links: %{
        puchases: "https://fakeapi.nubank.com.br/purchases"
      }
    }

    {:ok, access: access, purchases_fixture: purchases_fixture}
  end

  describe "NubankAPI.Feature.Purchases.fetch_purchases/1" do
    test "parses the response from the API to %Purchase{}", %{
      access: access,
      purchases_fixture: purchases_fixture
    } do
      expect(HTTP, :get, fn :purchases, ^access -> {:ok, purchases_fixture} end)
      expected_length = Enum.count(purchases_fixture["transactions"])

      {:ok, purchases} = Purchases.fetch_purchases(access)

      assert Enum.count(purchases) == expected_length

      Enum.each(purchases, fn purchase ->
        assert %Purchase{} = purchase
      end)
    end
  end

  describe "NubankAPI.Feature.Purchases.list_known_categories/0" do
    test "return a list of known categories as atoms" do
      categories = Purchases.list_known_categories()

      Enum.each(categories, fn category ->
        assert is_atom(category)
      end)
    end
  end

  describe "NubankAPI.Feature.Purchases.list_known_status/0" do
    test "return a list of known statuses as atoms" do
      statuses = Purchases.list_known_status()

      Enum.each(statuses, fn status ->
        assert is_atom(status)
      end)
    end
  end

  describe "NubankAPI.Feature.Purchases.list_known_event_types/0" do
    test "return a list of known event_types as atoms" do
      event_types = Purchases.list_known_event_types()

      Enum.each(event_types, fn event_type ->
        assert is_atom(event_type)
      end)
    end
  end
end
