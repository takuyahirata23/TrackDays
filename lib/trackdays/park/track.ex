defmodule Trackdays.Park.Track do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tracks" do
    field :name, :string
    field :length, :float

    belongs_to :facility, Trackdays.Park.Facility

    timestamps()
  end

  def changeset(tracks, attrs \\ %{}) do
    tracks
    |> cast(attrs, [:name, :length])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_number(:length, greater_than: 1)
    |> unique_constraint([:track_id, :name], message: "Nope")
  end
end
