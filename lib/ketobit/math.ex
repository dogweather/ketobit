defmodule Ketobit.Math do

  # Format an int or float safely to one decimal point.
  def round_decimal(number) do
    round(number * 10) / 10
  end

end
