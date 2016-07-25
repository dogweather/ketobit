defmodule Ketobit.MathTest do
  use Ketobit.ModelCase

  test "round_decimal handles integers" do
    rounded = Ketobit.Math.round_decimal(20)
    assert 20.0 = rounded
  end

  test "round_decimal rounds up" do
    rounded = Ketobit.Math.round_decimal(5.99)
    assert 6.0 = rounded
  end

  test "round_decimal rounds down" do
    rounded = Ketobit.Math.round_decimal(5.14147469)
    assert 5.1 = rounded
  end

  test "round_decimal handles zero" do
    rounded = Ketobit.Math.round_decimal(0)
    assert 0.0 = rounded
  end

end
