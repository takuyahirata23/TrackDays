defmodule TrackdaysWeb.UserSessionController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts
  alias TrackdaysWeb.Auth
  alias Trackdays.Mailer
  alias Trackdays.Emails.UserEmail

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_status(404)
        |> render(:user_not_found)

      user ->
        conn
        |> put_status(200)
        |> render(:login, user: user, token: Auth.generate_token(user.id))
    end
  end

  # attrs => %{"email" => email, "password" => password, name => name}
  def register(conn, attrs) do
    case Accounts.register_user(attrs) do
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(:user_registration_error, changeset: changeset)

      {:ok, user} ->
        res =
          user
          |> UserEmail.welcome("http://localhost:4000/auth/verify/#{user.id}")
          |> Mailer.deliver()

        IO.inspect(res)

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
end
