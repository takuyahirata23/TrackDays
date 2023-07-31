defmodule Trackdays.Repo.Migrations.CreateFacility do
  use Ecto.Migration

  def change do
    create table(:tracks, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :citext, null: false)
      add(:description, :string, size: 200)

      timestamps()
    end

    create(unique_index(:tracks, [:name]))

    create table(:layouts, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, size: 50, null: false)
      add(:length, :float, null: false)

      add :track_id, references(:tracks, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:layouts, [:track_id]))
    create(unique_index(:layouts, [:track_id, :name]))
  end
end
