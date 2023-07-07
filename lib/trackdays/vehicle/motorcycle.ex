defmodule Trackdays.Vehicle.Motorcycle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "motorcycles" do
    field :name, :integer
    timestamps()
  end

  def chagneset(motorcycle, attrs \\ %{}) do
    motorcycle
    |> cast(attrs, [:year, :user_id, :make_id, :model_id])
    |> validate_required([:year, :user_id, :make_id, :model_id])
    |> validate_number(:year,
      greater_than: 1960,
      less_than_or_equal_to: DateTime.utc_now() |> Map.fetch!(:year)
    )
  end
end
