defmodule :"Elixir.Trackdays.Repo.Migrations.Account-type" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_private, :boolean, default: true, null: false
    end

    execute "update users set is_private = true"
  end
end
