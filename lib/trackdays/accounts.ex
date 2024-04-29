defmodule Trackdays.Accounts do
  import Ecto.Query, warn: false

  alias Ecto.Repo
  alias Ecto.Multi
  alias Trackdays.Accounts.{NewEmailVerification, PasswordUpdateRequest, Group}
  alias Trackdays.Repo

  alias Trackdays.Accounts.User
  alias TrackdaysWeb.Auth

  @bucket_name System.get_env("BUCKET")

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_id(id) when is_binary(id) do
    Repo.one(from u in User, where: u.id == ^id and not is_nil(u.confirmed_at))
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

  def get_user_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  def verify_user(id) do
    case get_unverified_user_by_id(id) do
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

  def upsert_profile_image_url(url, user) when is_binary(url) do
    user = Ecto.Changeset.change(user, image_url: url)
    Repo.update(user)
  end

  def create_new_email_verification(email, user) do
    attrs = Map.put(email, "user_id", user.id)

    %NewEmailVerification{}
    |> NewEmailVerification.changeset(attrs)
    |> Repo.insert()
  end

  def get_email_verification(email, user) do
    Repo.one(from n in NewEmailVerification, where: n.email == ^email and n.user_id == ^user.id)
  end

  def verify_new_email(id) when is_binary(id) do
    email_verification = Repo.one(from e in NewEmailVerification, where: e.id == ^id)
    user = Repo.one(from u in User, where: u.id == ^email_verification.user_id)

    user = Ecto.Changeset.change(user, email: email_verification.email)

    Multi.new()
    |> Multi.update(:email_update, user)
    |> Multi.delete(:delete_email_verification, email_verification)
    |> Repo.transaction()
  end

  def create_password_update_request(attrs) do
    %PasswordUpdateRequest{}
    |> PasswordUpdateRequest.changeset(attrs)
    |> Repo.insert()
  end

  def get_password_update_request_by_id(id) do
    Repo.one(from p in PasswordUpdateRequest, where: p.id == ^id)
  end

  def update_password(user, password, password_update_request) do
    password_update_request =
      Repo.one(
        from p in PasswordUpdateRequest,
          where: p.id == ^password_update_request.id and p.user_id == ^user.id
      )

    user =
      user
      |> Ecto.Changeset.change(password: password)
      |> User.changeset()

    Multi.new()
    |> Multi.update(:password_update, user)
    |> Multi.delete(:delete_password_update_request, password_update_request)
    |> Repo.transaction()
  end

  def delete_user_account(user) do
    filename = "#{user.id}-profile.jpg"

    case user.image_url do
      nil ->
        Repo.delete(user)

      _ ->
        case ExAws.S3.delete_object(@bucket_name, filename) |> ExAws.request() do
          {:ok, _} ->
            Repo.delete(user)

          _ ->
            {:error, %{message: "Failed. Please try it later."}}
        end
    end
  end

  def create_group(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def get_groups do
    Repo.all(Group)
  end

  def update_group(user, group_id) do
    user
    |> Ecto.Changeset.change(group_id: group_id)
    |> User.group_update_changeset()
    |> Repo.update()
  end

  def update_account_type(is_private, user)
      when is_boolean(is_private) do
    user
    |> Ecto.Changeset.change(is_private: is_private)
    |> Repo.update()
  end

  def count_users do
    query = from u in User, select: count(u.id)
    Repo.one(query)
  end
end
