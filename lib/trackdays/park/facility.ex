defmodule Trackdays.Park.Facility do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "facilities" do
    field :name, :string
    field :description, :string

    has_many :tracks, Trackdays.Park.Track

    timestamps()
  end

  def changeset(facility, attrs \\ %{}) do
    facility
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:description, min: 2, max: 200, message: "Descripton must be less than 200")
    |> unique_constraint(:name, message: "#{attrs["name"]} already exists")
  end
end
