defmodule Trackdays.Accounts.NewEmailVerification do
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "new_email_verifications" do
    field :email, :string
    field :user_id, :binary_id

    timestamps()
  end

  def changeset(new_email_verification, attrs \\ %{}) do
    new_email_verification
    |> cast(attrs, [:email, :user_id])
    |> validate_email()
  end


  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Trackdays.Repo)
    |> unique_constraint(:email)
  end
end
