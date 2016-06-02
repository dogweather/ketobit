defmodule Ketobit.UserTest do
  use Ketobit.ModelCase

  alias Ketobit.User

  @valid_attrs %{access_token: "some content", email: "some content", name: "some content", refresh_token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
