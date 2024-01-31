defmodule Trackdays.Repo.Migrations.TrackdayDescriptionLength do
  use Ecto.Migration

  def change do
    alter table(:trackdays) do
      modify :description, :text, from: {:string}
    end
  end
end
