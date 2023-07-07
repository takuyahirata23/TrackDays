defmodule Trackdays.Vehicle.Make do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackdays.Vehicle.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "makes" do
    field :name, :string

    has_many :models, Model

    timestamps()
  end

  def changeset(make, attrs \\ %{}) do
    make
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 30)
    |> unique_constraint(:name, message: "#{attrs["name"]} already exists")
  end
end
