defmodule Ketobit.DateTest do
  use Ketobit.ModelCase
  use Timex

  test "iso_8601" do
    date = DateTime.from({2014, 3, 16})
    formatted = Ketobit.Date.iso_8601(date)
    assert "2014-03-16" = formatted
  end

end
