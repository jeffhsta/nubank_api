defmodule NubankAPI.Feature.EventsTest do
  use ExUnit.Case, async: true
  import Mox

  alias NubankAPI.{Access, Event}
  alias NubankAPI.Feature.Events
  alias NubankAPI.Mock.HTTP

  setup do
    events_fixture = NubankAPI.TestHelper.load_fixture(:events)

    access = %Access{
      access_token: "fake_access_token",
      refresh_before: DateTime.utc_now(),
      refresh_token: "fake_refresh_token",
      token_type: "bearer",
      links: %{
        events: "https://fakeapi.nubank.com.br/events"
      }
    }

    {:ok, access: access, events_fixture: events_fixture}
  end

  describe "NubankAPI.Feature.Events.fetch_events/1" do
    test "parses the response from the API to %Event{}", %{
      access: access,
      events_fixture: events_fixture
    } do
      expect(HTTP, :get, fn :events, ^access -> {:ok, events_fixture} end)
      expected_lenth = Enum.count(events_fixture["events"])

      {:ok, events} = Events.fetch_events(access)

      assert Enum.count(events) == expected_lenth

      Enum.each(events, fn event ->
        assert %Event{} = event
      end)
    end
  end

  describe "NubankAPI.Feature.Events.fetch_events/2" do
    test "filter only events from 'transaction' category", %{
      access: access,
      events_fixture: events_fixture
    } do
      expect(HTTP, :get, fn :events, ^access -> {:ok, events_fixture} end)

      {:ok, events} = Events.fetch_events(access, category: :transaction)

      assert Enum.count(events) == 1
      assert [event = %Event{}] = events
      assert event.category == :transaction
    end
  end

  describe "NubankAPI.Feature.Events.list_known_categories/0" do
    test "return a list of known categories as atoms" do
      categories = Events.list_known_categories()

      Enum.each(categories, fn category ->
        assert is_atom(category)
      end)
    end

    test "return a list of known categories with no duplicates" do
      categories = Events.list_known_categories()

      expected_lenth =
        categories
        |> MapSet.new()
        |> Enum.count()

      assert expected_lenth == Enum.count(categories)

      Enum.each(categories, fn category ->
        assert is_atom(category)
      end)
    end
  end
end
