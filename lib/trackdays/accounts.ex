defmodule Trackdays.Accounts do
  import Ecto.Query, warn: false

  alias Trackdays.Repo

  alias Trackdays.Accounts.User

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
