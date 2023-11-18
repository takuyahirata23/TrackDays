defmodule Trackdays.Repo.Migrations.AddNewEmailVerifyTable do
  use Ecto.Migration

  def change do
    create table(:new_email_verifications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :user_id, :binary_id, null: false

      timestamps()
    end
  end
end
