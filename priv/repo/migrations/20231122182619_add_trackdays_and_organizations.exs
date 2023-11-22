defmodule Trackdays.Repo.Migrations.AddTrackdaysAndOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, size: 50, null: false
      add :trackdays_registration_url, :string

      timestamps()
    end

    create(unique_index(:organizations, [:name], name: :organazation_name_constraint))

    create table(:trackdays, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add :date, :date, null: false
      add :price, :integer, null: false

      add :track_id, references(:tracks, type: :binary_id, on_delete: :nothing, null: false)

      add :organization_id,
          references(:organizations, type: :binary_id, on_delete: :nothing, null: false)

      timestamps()
    end

    create(index(:trackdays, [:date]))
    create(unique_index(:trackdays, [:organization_id, :date, :track_id], name: :trackdays_constraint))
  end
end
