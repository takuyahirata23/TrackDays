defmodule :"Elixir.Trackdays.Repo.Migrations.Update-trackdays-unique-index" do
  use Ecto.Migration

  def change do
    create(
      unique_index(:trackdays, [:organization_id, :start_datetime, :track_id],
        name: :trackdays_constraint
      )
    )

    create(index(:trackdays, [:start_datetime, :end_datetime]))
  end
end
