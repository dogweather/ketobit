defmodule Ketobit.Date do
  use Timex

  @spec today(String.t) :: DateTime.t
  def today(in_timezone) when is_bitstring(in_timezone) do
    DateTime.now |> Timezone.convert(in_timezone)
  end


  @spec iso_8601(DateTime.t) :: String.t
  def iso_8601(date = %DateTime{}) do
    {:ok, iso_8601} = Timex.format(date, "%Y-%m-%d", :strftime)
    iso_8601
  end

end
