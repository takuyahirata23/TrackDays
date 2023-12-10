defmodule Trackdays.Repo.Migrations.Group do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, size: 30, null: false

      timestamps()
    end

    alter table(:users) do
      add(:group_id, references(:groups, type: :binary_id, on_delete: :nothing))
    end
  end
end
