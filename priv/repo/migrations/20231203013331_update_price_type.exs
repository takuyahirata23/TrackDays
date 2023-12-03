defmodule Trackdays.Repo.Migrations.UpdatePriceType do
  use Ecto.Migration

  def change do
    alter table(:trackdays) do
      modify :price, :float, null: false
      add :description, :string
    end
  end
end
