defmodule Ketobit.Math do

  # Format an int or float safely to one decimal point.
  def round_decimal(number) do
    Float.floor(number / 1, 1)
  end

end
