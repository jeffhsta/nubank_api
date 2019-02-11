defmodule NubankAPITest do
  use ExUnit.Case

  test "NubankAPI has a function transactions/1" do
    functions =
      :functions
      |> NubankAPI.__info__()
      |> Enum.map(fn {func_name, func_args_count} -> "#{func_name}/#{func_args_count}" end)

    assert "transactions/1" in functions
  end
end
