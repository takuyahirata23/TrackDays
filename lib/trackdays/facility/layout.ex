defmodule Trackdays.Facility.Layout do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "layouts" do
    field :name, :string
    field :length, :float

    belongs_to :track, Trackdays.Facility.Track

    timestamps()
  end

  def changeset(layout, attrs \\ %{}) do
    layout
    |> cast(attrs, [:name, :description, :lenght, :track_id])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:description, max: 200)
    |> validate_number(:length, greater_than: 1)
    |> unique_constraint([:name, :track_id])
  end
end
