defmodule Ketobit.Math do

  # Format to one decimal point
  @spec round_decimal(number) :: float
  def round_decimal(n) when is_number(n) do
    round(n * 10) / 10
  end

end
