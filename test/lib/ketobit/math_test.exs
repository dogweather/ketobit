import Ketobit.Math

defmodule Ketobit.MathTest do
  use Ketobit.ModelCase

  # round_decimal

  test "handles integers" do
    assert 20.0 = round_decimal(20)
  end

  test "rounds up" do
    assert 6.0 = round_decimal(5.99)
  end

  test "rounds down" do
    assert 5.1 = round_decimal(5.14147469)
  end

  test "handles zero" do
    assert 0.0 = round_decimal(0)
  end

end
