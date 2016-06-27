defmodule Ketobit.PageControllerTest do
  use Ketobit.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in with Fitbit"
  end
end
