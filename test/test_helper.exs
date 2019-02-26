Mox.defmock(NubankAPI.Mock.HTTP, for: NubankAPI.HTTP)

defmodule NubankAPI.TestHelper do
  def load_fixture(fixture) do
    "#{__DIR__}/fixtures/#{fixture}.json"
    |> File.read!()
    |> Poison.decode!()
  end
end

ExUnit.start()
