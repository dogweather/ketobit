defmodule Ketobit.Date do
  use Timex

  def iso_8601(date = %DateTime{}) do
    {:ok, iso_8601} = Timex.format(date, "%Y-%m-%d", :strftime)
    iso_8601
  end

end
