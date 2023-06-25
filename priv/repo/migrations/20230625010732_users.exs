defmodule Trackdays.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, size: 50, null: false
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :is_admin, :boolean, default: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
