defmodule Trackdays.Repo.Migrations.PasswordUpdateRequests do
  use Ecto.Migration

  def change do
    create table(:password_update_requests, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false)

      timestamps()
    end
  end
end
