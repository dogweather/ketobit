defmodule Ketobit.AuthController do
  use Ketobit.Web, :controller

  def index(conn, _params) do
    redirect conn, external: Fitbit.authorize_url!(scope: "profile nutrition")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"code" => authorization_code}) do
    token = Fitbit.get_token!(code: authorization_code)
    user_id = token.other_params["user_id"]

    # So far, we don't need to actually save any info in the database.
    #
    # changeset = User.changeset(%User{},
    #   %{user_id: user_id,
    #     access_token: token.access_token,
    #     refresh_token: token.refresh_token,
    #     name: user_name
    #   })
    # Repo.insert!(changeset)

    conn
      |> put_session(:token, token)
      |> put_session(:current_user, user_id)
      |> redirect(to: "/")
  end
end
