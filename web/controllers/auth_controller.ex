defmodule Ketobit.AuthController do
  use Ketobit.Web, :controller

  def index(conn, _params) do
    redirect conn, external: Fitbit.authorize_url!(scope: "nutrition")
  end

  def callback(conn, %{"code" => code}) do
    token = Fitbit.get_token!(code: code)
    IO.inspect token

    changeset = Ketobit.User.changeset(%Ketobit.User{},
      %{user_id: token.other_params["user_id"],
        access_token: token.access_token,
        refresh_token: token.refresh_token
      })
    Repo.insert!(changeset)

    conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: "/")
  end
end
