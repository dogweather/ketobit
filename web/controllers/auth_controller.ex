defmodule Ketobit.AuthController do
  use Ketobit.Web, :controller
  use Timex
  alias Ketobit.User

  def index(conn, _params) do
    redirect conn, external: Fitbit.authorize_url!(scope: "profile nutrition")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"code" => code}) do
    token = Fitbit.get_token!(code: code)

    user_data = OAuth2.AccessToken.get!(token, "/1/user/-/profile.json").body
    user_name = user_data["user"]["displayName"]
    user_id   = token.other_params["user_id"]

    # So far, we don't need to actually save any info in the database.
    #
    # changeset = User.changeset(%User{},
    #   %{user_id: user_id,
    #     access_token: token.access_token,
    #     refresh_token: token.refresh_token,
    #     name: user_name
    #   })
    # Repo.insert!(changeset)

    # Get today's food log
    # TODO: Ensure this is the *user's* current date (& timezone).
    today    = DateTime.today
    timezone = Timex.timezone("America/Los_Angeles", today)
    {:ok, today_8601} = today
      |> Timezone.convert(timezone)
      |> Timex.format("%Y-%m-%d", :strftime)
    food_log = OAuth2.AccessToken.get!(token, "/1/user/-/foods/log/date/#{today_8601}.json").body

    # Calculate the info we're interested in
    net_carbs   = food_log["summary"]["carbs"] - food_log["summary"]["fiber"]
    keto_budget = 20 - net_carbs

    conn
      |> put_flash(:info, "Hello #{user_name}!")
      |> put_session(:current_user, user_id)
      |> put_session(:access_token, token.access_token)
      |> put_session(:net_carbs, net_carbs)
      |> put_session(:keto_budget, keto_budget)
      |> redirect(to: "/")
  end
end
