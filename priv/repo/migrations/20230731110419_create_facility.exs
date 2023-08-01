defmodule Trackdays.Repo.Migrations.CreateFacility do
  use Ecto.Migration

  def change do
    create table(:facilities, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :citext, null: false)
      add(:description, :string, size: 200)

      timestamps()
    end

    create(unique_index(:facilities, [:name]))

    create table(:tracks, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, size: 50, null: false)
      add(:length, :float, null: false)

      add :facility_id,
          references(:facilities, type: :binary_id, on_delete: :delete_all, null: false)

      timestamps()
    end

    create(index(:tracks, [:facility_id]))
    create(unique_index(:tracks, [:facility_id, :name]))
  end
end
