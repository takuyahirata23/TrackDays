defmodule Trackdays.Repo.Migrations.TrackdayNoteGroup do
  use Ecto.Migration

  def change do
    alter table(:trackday_notes) do
      add :group_id, references(:groups, type: :binary_id, on_delete: :nothing, null: false)
    end
  end
end
