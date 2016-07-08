defmodule Ketobit.PageController do
  use Ketobit.Web, :controller
  use Timex
  require Logger

  @default_carb_limit 20

  def index(conn, _params) do
    token = get_session(conn, :token)
    cond do
      is_nil(token) -> welcome_page(conn)
      true          -> info_page(conn, token)
    end
  end

  defp welcome_page(conn) do
    render(conn, "index.html")
  end

  defp info_page(conn, token) do
    case OAuth2.AccessToken.get(token, "/1/user/-/profile.json") do
      {:ok, %OAuth2.Response{status_code: 401}} ->
        # TODO: Use the proper refresh token procedure
        redirect(conn, to: "/auth")
      {:ok, %OAuth2.Response{status_code: 200, body: body}} ->
        info_page(conn, token, body)
      {:error, %OAuth2.Error{reason: reason}} ->
        Logger.error("Error: #{inspect reason}")
    end
  end

  defp info_page(conn, token, %{"user" => user_data}) do
    %{
      "displayName" => user_name,
      "timezone" => user_timezone_string,
      "avatar" => avatar_url
    } = user_data

    IO.inspect("Got user #{user_name} in timezone #{user_timezone_string}")

    # Get today's food log
    timezone = user_timezone_string
      |> Timex.timezone(DateTime.now)

    {:ok, today_iso_8601} = DateTime.now
      |> Timezone.convert(timezone)
      |> Timex.format("%Y-%m-%d", :strftime)

    %{"summary" => summary} = OAuth2.AccessToken.get!(token, "/1/user/-/foods/log/date/#{today_iso_8601}.json").body
    %{"carbs" => carbs, "fiber" => fiber} = summary

    net_carbs   = carbs - fiber
    keto_budget = @default_carb_limit - net_carbs

    conn
      |> assign(:keto_budget, round_decimal(keto_budget))
      |> assign(:avatar_url, avatar_url)
      |> render("info.html")
  end

  # Format an int or float safely to one decimal point.
  defp round_decimal(number) do
    Float.floor(number / 1, 1)
  end
end
