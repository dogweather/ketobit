defmodule Ketobit.MathTest do
  use Ketobit.ModelCase

  test "round_decimal handles integers" do
    rounded = Ketobit.Math.round_decimal(5)
    assert 5.0 = rounded
  end

  test "round_decimal simply truncates" do
    rounded = Ketobit.Math.round_decimal(5.99)
    assert 5.9 = rounded
  end

end
