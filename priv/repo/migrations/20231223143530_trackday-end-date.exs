defmodule :"Elixir.Trackdays.Repo.Migrations.Trackday-end-date" do
  use Ecto.Migration

  def change do
    alter table(:trackdays) do
      add :start_datetime, :naive_datetime, null: false
      add :end_datetime, :naive_datetime, null: false

      remove :date, :naive_datetime
    end
  end
end
