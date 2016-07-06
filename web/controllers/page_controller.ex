defmodule Ketobit.PageController do
  use Ketobit.Web, :controller
  use Timex

  def index(conn, _params) do
    token = get_session(conn, :token)
    cond do
      is_nil(token) -> welcome_page(conn)
      true          -> signed_in_page(conn, token)
    end
  end

  defp welcome_page(conn) do
    render conn, "index.html"
  end

  defp signed_in_page(conn, token) do
    %{body: %{
      "user" => %{
        "displayName" => user_name,
        "timezone" => user_timezone_string,
        "avatar" => avatar_url
        }
      }
    } = OAuth2.AccessToken.get!(token, "/1/user/-/profile.json")

    IO.inspect("Got user #{user_name} in timezone #{user_timezone_string} and avatar #{avatar_url}")

    # Get today's food log
    timezone = user_timezone_string
      |> Timex.timezone(DateTime.now)

    {:ok, today_iso_8601} = DateTime.now
      |> Timezone.convert(timezone)
      |> Timex.format("%Y-%m-%d", :strftime)

    IO.inspect("Requesting food log for #{today_iso_8601}")

    %{"summary" => summary} = OAuth2.AccessToken.get!(token, "/1/user/-/foods/log/date/#{today_iso_8601}.json").body
    IO.inspect(summary)

    # Calculate the info we're interested in
    net_carbs   = summary["carbs"] - summary["fiber"]
    keto_budget = 20 - net_carbs

    conn
      |> put_flash(:info, "Hello #{user_name}!")
      |> assign(:keto_budget, keto_budget)
      |> render("index.html")
  end
end
