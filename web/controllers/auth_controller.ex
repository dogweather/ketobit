defmodule Ketobit.AuthController do
  use Ketobit.Web, :controller

  def index(conn, _params) do
    redirect conn, external: Fitbit.authorize_url!(scope: "nutrition")
  end
end
