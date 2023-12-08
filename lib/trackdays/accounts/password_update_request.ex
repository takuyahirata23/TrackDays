defmodule Trackdays.Accounts.PasswordUpdateRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "password_update_requests" do
    belongs_to :user, Trackdays.Accounts.User

    timestamps()
  end

  def changeset(password_update_request, attrs \\ %{}) do
    password_update_request
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
