defmodule Trackdays.Event.Trackday do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "trackdays" do
    field :date, :string 
    field :trackdays_registration_url, :string 

    belongs_to :organization, Trackdays.Business.Organization

    timestamps()
  end 

  def changeset(trackday, attrs \\ %{}) do
    trackday
    |> cast(attrs, [:date, :trackdays_registration_url, :organization_id, :track_id])
    |> unique_constraint([:organization_id, :date, :track_id],
      name: :trackdays_constraint,
      messeage: "Your trackday on this date already exists"
    )
  end
end
