defmodule Trackdays.Repo.Migrations.TrackdayDefaultNote do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :default_note, :text
    end
  end
end
