defmodule :"Elixir.Trackdays.Repo.Migrations.Trackday-date" do
  use Ecto.Migration

  def change do
    alter table(:trackdays) do
      modify :date, :naive_datetime
    end
  end
end
