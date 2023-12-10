defmodule Trackdays.Repo.Migrations.GroupNonNull do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :group_id,
             references(:groups, type: :binary_id, on_delete: :nothing),
             null: false,
             from: references(:groups, type: :binary_id, on_delete: :nothing)
    end
  end
end
