defmodule TrackdaysWeb.AccountController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts
  alias Trackdays.Accounts.{PasswordUpdateRequest}

  def verification_success(conn, _attrs) do
    render(conn, :verification_success, layout: false)
  end

  def verification_fail(conn, _attrs) do
    render(conn, :verification_fail, layout: false)
  end

  # attrs = %{"id" => password_update_request_id}
  def forgot_password(conn, %{"id" => password_update_request_id}) do
    case Accounts.get_password_update_request_by_id(password_update_request_id) do
      %PasswordUpdateRequest{} = _password_update_request ->
        conn
        |> redirect(to: "/accounts/update-password")
    end
  end
end
