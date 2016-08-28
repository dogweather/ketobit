defmodule Ketobit.DateTest do
  use Ketobit.ModelCase
  use Timex

  test "iso_8601 works with a DateTime" do
    date = DateTime.from({2014, 3, 16})
    formatted = Ketobit.Date.iso_8601(date)
    assert "2014-03-16" = formatted
  end

  test "iso_8601 won't execute with an integer" do
    assert_raise FunctionClauseError, fn ->
      Ketobit.Date.iso_8601(123)
    end
  end

end
