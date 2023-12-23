defmodule :"Elixir.Trackdays.Repo.Migrations.Calendar-sync" do
  use Ecto.Migration

  def change do
    create table(:user_trackday_calendar, primary_key: false) do
      add :id, :binary, primary_key: true
      add :trackday_id, references(:trackdays, type: :binary_id, on_delete: :delete_all),
        null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :calendar_id, :string, null: false

      timestamps()
    end

    create(index(:user_trackday_calendar, [:user_id, :trackday_id]))

    create(
      unique_index(:user_trackday_calendar, [:user_id, :trackday_id, :calendar_id],
        name: :user_trackday_calendar_constraint
      )
    )
  end
end
