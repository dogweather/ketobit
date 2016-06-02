defmodule Ketobit.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :access_token, :text
      add :refresh_token, :text

      timestamps
    end

  end
end
