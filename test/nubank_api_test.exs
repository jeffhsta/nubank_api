defmodule NubankApiTest do
  use ExUnit.Case
  doctest NubankApi

  test "greets the world" do
    assert NubankApi.hello() == :world
  end
end
