defmodule Ketobit.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :user_id, :string
      add :access_token, :binary
      add :refresh_token, :binary
      add :expires_at, :datetime

      timestamps
    end
  end
end
