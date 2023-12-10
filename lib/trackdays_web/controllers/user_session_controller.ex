defmodule TrackdaysWeb.UserSessionController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts
  alias TrackdaysWeb.Auth
  alias Trackdays.Mailer
  alias Trackdays.Emails.UserEmail
  alias Trackdays.Accounts.User

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_status(404)
        |> render(:user_not_found)

      %User{confirmed_at: nil} ->
        conn
        |> put_status(401)
        |> render(:user_not_verified)

      %User{} = user ->
        conn
        |> put_status(200)
        |> render(:login, user: user, token: Auth.generate_token(user.id))
    end
  end

  # attrs => %{"email" => email, "password" => password, name => name, "group_id" => group_id}
  def register(conn, attrs) do
    case Accounts.register_user(attrs) do
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(:user_registration_error, changeset: changeset)

      {:ok, user} ->
        user
        |> UserEmail.welcome("/auth/verify/#{user.id}")
        |> Mailer.deliver()

        conn
        |> put_status(201)
        |> render(:register, user: user, token: Auth.generate_token(user.id))
    end
  end

  def verify(conn, %{"id" => id}) do
    case Accounts.verify_user(id) do
      :error ->
        conn
        |> redirect(to: "/accounts/verification_fail")

      :ok ->
        conn
        |> redirect(to: "/accounts/verification_success")
    end
  end

  # attrs = %{"email" => email}
  def update_email(conn, attrs) do
    user = conn.assigns.current_user

    case Accounts.create_new_email_verification(attrs, user) do
      {:ok, new_email_verification} ->
        UserEmail.new_email_verification(
          user.name,
          new_email_verification.email,
          "/auth/verify-new-email/#{new_email_verification.id}"
        )
        |> Mailer.deliver()

        conn
        |> put_status(200)
        |> render(:update_email)

      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(:update_email_error, changeset: changeset)
    end
  end

  # attrs = %{"email" => email}
  def create_password_update_request(conn, attrs) do
    with %User{} = user <- Accounts.get_user_by_email(attrs["email"]),
         {:ok, password_update_request} <-
           Accounts.create_password_update_request(%{user_id: user.id}) do
      UserEmail.password_update_request(
        user,
        "accounts/forgot-password/#{password_update_request.id}"
      )
      |> Mailer.deliver()

      conn
      |> put_status(200)
      |> render(:password_request_accepted)
    else
      _ ->
        conn
        |> put_status(404)
        |> render(:password_request_declined)
    end
  end

  def verify_new_email(conn, %{"id" => id}) do
    case Accounts.verify_new_email(id) do
      {:ok, _} ->
        conn
        |> redirect(to: "/accounts/verification_success")

      {:error, _} ->
        conn
        |> redirect(to: "/accounts/verification_fail")
    end
  end

  def delete_account(conn, _) do
    case Accounts.delete_user_account(conn.assigns.current_user) do
      {:ok, _} ->
        conn
        |> put_status(200)
        |> render(:user_account_deleted)

      _ ->
        conn
        |> put_status(500)
        |> render(:user_account_not_deleted)
    end
  end
end
