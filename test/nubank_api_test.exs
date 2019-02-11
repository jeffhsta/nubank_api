defmodule NubankAPITest do
  use ExUnit.Case
  doctest NubankAPI

  test "greets the world" do
    assert NubankAPI.hello() == :world
  end
end
