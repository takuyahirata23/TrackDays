defmodule TrackdaysWeb.UserSessionController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts
  alias TrackdaysWeb.Auth

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
        conn
        |> put_status(201)
        |> render(:register, user: user, token: Auth.generate_token(user.id))
    end
  end
end
