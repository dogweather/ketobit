defmodule Ketobit.AuthController do
  use Ketobit.Web, :controller
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

    data = OAuth2.AccessToken.get!(token, "/1/user/-/profile.json").body
    IO.inspect data

    user_name = data["user"]["displayName"]
    user_id   = token.other_params["user_id"]

    changeset = User.changeset(%User{},
      %{user_id: user_id,
        access_token: token.access_token,
        refresh_token: token.refresh_token,
        name: user_name
      })
    Repo.insert!(changeset)

    conn
      |> put_flash(:info, "Hello #{user_name}!")
      |> put_session(:current_user, user_id)
      |> put_session(:access_token, token.access_token)
      |> redirect(to: "/")
  end
end
