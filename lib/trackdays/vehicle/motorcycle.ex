defmodule Trackdays.Vehicle.Motorcycle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "motorcycles" do
    field :year, :integer
    field :user_id, :binary_id
    field :model_id, :binary_id
    timestamps()
  end

  def chagneset(motorcycle, attrs \\ %{}) do
    motorcycle
    |> cast(attrs, [:year, :model_id, :user_id])
    |> validate_required([:year, :model_id, :user_id])
    |> validate_number(:year,
      greater_than: 1960,
      less_than_or_equal_to: DateTime.utc_now() |> Map.fetch!(:year)
    )
    |> unique_constraint([:user_id, :model_id, :year],
      name: :motorcycle_constraint,
      message: "Already registerd"
    )
  end
end
