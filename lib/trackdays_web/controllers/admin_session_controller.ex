defmodule TrackdaysWeb.AdminSessionController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts
  alias TrackdaysWeb.Auth

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, "Log in")
      |> Auth.log_in_to_admin(user)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/admin/log_in")
    end
  end
end
