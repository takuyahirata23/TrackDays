defmodule TrackdaysWeb.UserSessionJSON do
  alias TrackdaysWeb.Controllers.Helpers

  def user_not_found(_) do
    %{error: true, message: "Not found"}
  end

  def user_not_verified(_) do
    %{error: true, message: "Please verify your email"}
  end

  def login(%{user: user, token: token}) do
    %{error: false, message: "User found", user: user, token: token}
  end

  def user_registration_error(%{changeset: changeset}) do
    %{error: true, message: "User registration error", errors: Helpers.format_errors(changeset)}
  end

  def register(%{user: user, token: token}) do
    %{error: false, message: "User registered", user: user, token: token}
  end

  def (%{user: user, token: token}) do
    %{error: false, message: "User registered", user: user, token: token}
  end

  def user_account_deleted(_) do
    %{error: false, message: "User deleted"}
  end

  def user_account_not_deleted(_) do
    %{error: true, message: "User not deleted. Please try it later."}
  end

  def update_email(_) do
    %{error: false, message: "Send new email verification email"}
  end

  def update_email_error(%{changeset: changeset}) do
    %{error: true, message: "Send new email verification email", errors: Helpers.format_errors(changeset)}
  end
end
