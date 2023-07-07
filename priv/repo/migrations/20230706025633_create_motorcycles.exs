defmodule Trackdays.Repo.Migrations.CreateMotorcycles do
  use Ecto.Migration

  def change do
    create table(:makes, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :citext, null: false)
      timestamps()
    end

    create(unique_index(:makes, [:name]))

    create table(:models, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :citext, null: false)
      add(:make_id, references(:makes, type: :binary_id, on_delete: :delete_all), null: false)
      timestamps()
    end

    create(index(:models, [:make_id]))
    create(unique_index(:models, [:name, :make_id]))

    create table(:motorcycles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:year, :integer, null: false)
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false)
      add(:make_id, references(:makes, type: :binary_id, on_delete: :delete_all), null: false)
      add(:model_id, references(:models, type: :binary_id, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:motorcycles, [:user_id]))

    create(
      unique_index(:motorcycles, [:user_id, :model_id, :year, :make_id],
        name: :motorcycle_constraint
      )
    )
  end
end
