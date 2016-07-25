defmodule Ketobit.Date do
  use Timex

  @spec today(String.t) :: DateTime.t
  def today(tz) when is_bitstring(tz) do
    timezone = Timex.timezone(tz, DateTime.now)
    Timezone.convert(DateTime.now, timezone)
  end


  @spec iso_8601(DateTime.t) :: String.t
  def iso_8601(date = %DateTime{}) do
    {:ok, iso_8601} = Timex.format(date, "%Y-%m-%d", :strftime)
    iso_8601
  end

end
