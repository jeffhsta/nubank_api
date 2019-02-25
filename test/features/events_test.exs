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
      expect(HTTP, :get, fn :events, ^access -> events_fixture end)
      expected_lenth = Enum.count(events_fixture["events"])

      {:ok, events} = Events.fetch_events(access)

      assert Enum.count(events) == expected_lenth

      Enum.each(events, fn event ->
        assert %Event{} = event
      end)
    end
  end

  describe "NubankAPI.Feature.Events.fetch_transactions" do
    test "parses the API response to a list of NubankAPI.Event", %{access: access} do
      expect(HTTP, :get, fn :events, ^access ->
        %{
          "events" => [
            %{
              "id" => "438F5BBF-92D9-4DA8-A8D1-E647DC3E314D",
              "description" => "Some description",
              "time" => "2019-02-09T14:36:15Z",
              "amount" => "1234",
              "title" => "A title",
              "category" => "transaction"
            }
          ]
        }
      end)

      {:ok, transactions} = Events.fetch_transactions(access)

      assert [%Event{} | _] = transactions
    end

    test "filter only events from 'transaction' category", %{
      access: access,
      events_fixture: events_fixture
    } do
      expect(HTTP, :get, fn :events, ^access -> events_fixture end)

      {:ok, transactions} = Events.fetch_transactions(access)

      assert Enum.count(transactions) == 1
      assert [event = %Event{}] = transactions
      assert event.category == :transaction
    end
  end
end
