defmodule :"Elixir.Trackdays.Repo.Migrations.Motorcycle-archive" do
  use Ecto.Migration

  def change do
    alter table(:motorcycles) do
      add :is_archived, :boolean
    end
  end
end
