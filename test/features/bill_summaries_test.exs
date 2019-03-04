defmodule NubankAPI.Feature.BillSummariesTest do
  use ExUnit.Case, async: true
  import Mox

  alias NubankAPI.{Access, BillSummary}
  alias NubankAPI.Feature.BillSummaries
  alias NubankAPI.Mock.HTTP

  setup do
    bill_summaries_fixture = NubankAPI.TestHelper.load_fixture(:bills_summaries)

    access = %Access{
      access_token: "fake_access_token",
      refresh_before: DateTime.utc_now(),
      refresh_token: "fake_refresh_token",
      token_type: "bearer",
      links: %{
        bills_summary: "https://fakeapi.nubank.com.br/bills_summary"
      }
    }

    {:ok, access: access, bill_summaries_fixture: bill_summaries_fixture}
  end

  describe "NubankAPI.Feature.BillSummaries.fetch_bill_summaries/1" do
    test "parses the response from the API to %BillSummary{}", %{
      access: access,
      bill_summaries_fixture: bill_summaries_fixture
    } do
      expect(HTTP, :get, fn :bills_summary, ^access -> {:ok, bill_summaries_fixture} end)
      expected_lenth = Enum.count(bill_summaries_fixture["bills"])

      {:ok, bill_summaries} = BillSummaries.fetch_bill_summaries(access)

      assert Enum.count(bill_summaries) == expected_lenth

      Enum.each(bill_summaries, fn bill_summary ->
        assert %BillSummary{} = bill_summary
      end)
    end
  end

  describe "NubankAPI.Feature.BillSummaries.fetch_bill_summaries/2" do
    test "filter only 'open' bills", %{
      access: access,
      bill_summaries_fixture: bill_summaries_fixture
    } do
      expect(HTTP, :get, fn :bills_summary, ^access -> {:ok, bill_summaries_fixture} end)

      {:ok, bill_summaries} = BillSummaries.fetch_bill_summaries(access, state: :open)

      assert Enum.count(bill_summaries) == 1
      assert [bill_summary = %BillSummary{}] = bill_summaries
      assert bill_summary.state == :open
    end

    test "filter only 'overdue' bills", %{
      access: access,
      bill_summaries_fixture: bill_summaries_fixture
    } do
      expect(HTTP, :get, fn :bills_summary, ^access -> {:ok, bill_summaries_fixture} end)

      {:ok, bill_summaries} = BillSummaries.fetch_bill_summaries(access, state: :overdue)

      assert Enum.count(bill_summaries) == 2

      Enum.each(bill_summaries, fn bill_summary ->
        assert %BillSummary{} = bill_summary
        assert bill_summary.state == :overdue
      end)
    end

    test "error when bill state do not exist", %{
      access: access,
      bill_summaries_fixture: bill_summaries_fixture
    } do
      expect(HTTP, :get, fn :bills_summary, ^access -> {:ok, bill_summaries_fixture} end)

      {:error, response} = BillSummaries.fetch_bill_summaries(access, state: :i_promise_to_pay)

      assert response == "Invalid bill state"
    end
  end

  describe "NubankAPI.Feature.BillSummaries.list_known_states/0" do
    test "return a list of known states as atoms" do
      states = BillSummaries.list_known_states()

      Enum.each(states, fn state ->
        assert is_atom(state)
      end)
    end
  end
end
