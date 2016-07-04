defmodule Ketobit.AuthController do
  use Ketobit.Web, :controller

  def index(conn, _params) do
    redirect conn, external: Fitbit.authorize_url!(scope: "profile nutrition")
  end

  def callback(conn, %{"code" => code}) do
    token = Fitbit.get_token!(code: code)

    data = OAuth2.AccessToken.get!(token, "/1/user/-/profile.json")
    IO.inspect data

    user_name = data["user"]["displayName"]

    changeset = User.changeset(%User{},
      %{user_id: token.other_params["user_id"],
        access_token: token.access_token,
        refresh_token: token.refresh_token,
        name: user_name
      })
    Repo.insert!(changeset)

    conn
      |> put_flash(:info, "Hello #{user_name}!")
      |> redirect(to: "/")
  end
end
