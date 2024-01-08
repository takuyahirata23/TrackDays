defmodule Trackdays.Business.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "organizations" do
    field :name, :string
    field :trackdays_registration_url, :string
    field :homepage_url, :string

    has_many :trackdays, Trackdays.Event.Trackday, preload_order: [asc: :start_datetime]

    timestamps()
  end

  def changeset(organization, attrs \\ %{}) do
    organization
    |> cast(attrs, [:name, :trackdays_registration_url, :homepage_url])
    |> validate_required([:name, :trackdays_registration_url])
    |> validate_length(:name, min: 2, max: 30)
    |> validate_length(:homepage_url, min: 2, max: 50)
    |> unique_constraint([:name],
      name: :organazation_name_constraint,
      message: "Organization already exists"
    )
  end
end
