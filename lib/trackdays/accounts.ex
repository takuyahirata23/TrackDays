defmodule Trackdays.Accounts do
  import Ecto.Query, warn: false

  alias Trackdays.Repo

  alias Trackdays.Accounts.User
  alias TrackdaysWeb.Auth

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_id(id) when is_binary(id) do
    Repo.get_by(User, id: id)
  end

  def get_user_by_token(token) when is_binary(token) do
    with {:ok, id} <- Auth.verify_token(token),
         %User{} = user <- get_user_by_id(id) do
      {:ok, user}
    else
      _ -> {:error, nil}
    end
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end
end
