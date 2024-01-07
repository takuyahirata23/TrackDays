defmodule TrackdaysWeb.AccountController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts
  alias Trackdays.Accounts.{PasswordUpdateRequest, User}

  def verification_success(conn, _attrs) do
    render(conn, :verification_success)
  end

  def verification_fail(conn, _attrs) do
    render(conn, :verification_fail)
  end

  # attrs = %{"id" => password_update_request_id}
  def forgot_password(conn, %{"id" => password_update_request_id}) do
    case Accounts.get_password_update_request_by_id(password_update_request_id) do
      %PasswordUpdateRequest{} = _password_update_request ->
        conn
        |> redirect(to: "/accounts/update-password")
    end
  end

  def delete_account_request(conn, _) do
    render(conn, :delete_account_request, message: nil)
  end

  def delete_account(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by_email_and_password(email, password),
         Accounts.delete_user_account(user) do
      render(conn, :delete_account_request,
        message: "Your account has been deleted. Thanks for using Motorcycle Trackdays!"
      )
    else
      nil ->
        render(conn, :delete_account_request,
          message: "Sorry something went wrong. User not found."
        )

      _ ->
        render(conn, :delete_account_request,
          message: "Sorry something went wrong. Please try again later."
        )
    end
  end
end
