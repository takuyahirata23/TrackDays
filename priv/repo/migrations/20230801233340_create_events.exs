defmodule Trackdays.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:trackday_notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :lap_time, :integer
      add :date, :date, null: false
      add :note, :string

      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all, null: false)
      add :track_id, references(:tracks, type: :binary_id, on_delete: :nothing, null: false)

      add :motorcycle_id,
          references(:motorcycles, type: :binary_id, on_delete: :nothing, null: false)

      timestamps()
    end

    create(index(:trackday_notes, [:user_id]))

    create(
      unique_index(:trackday_notes, [:user_id, :motorcycle_id, :date],
        name: :trackday_note_constraint
      )
    )
  end
end
