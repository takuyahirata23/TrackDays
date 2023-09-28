defmodule Trackdays.Accounts do
  import Ecto.Query, warn: false

  alias Ecto.Repo
  alias Trackdays.Accounts
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

  def get_unverified_user_by_id(id) when is_binary(id) do
    Repo.one(from u in User, where: u.id == ^id and is_nil(u.confirmed_at))
  end

  def get_user_by_token(token) when is_binary(token) do
    with {:ok, id} <- Auth.verify_token(token),
         %User{} = user <- get_user_by_id(id) do
      {:ok, user}
    else
      _ ->
        {:error, nil}
    end
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  def verify_user(id) do
    case Accounts.get_unverified_user_by_id(id) do
      nil ->
        :error

      user ->
        user =
          Ecto.Changeset.change(user,
            confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
          )

        case Repo.update(user) do
          {:ok, _user} -> :ok
          _ -> :error
        end
    end
  end
end
