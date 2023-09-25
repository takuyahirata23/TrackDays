defmodule TrackdaysWeb.UserSessionJSON do
  alias TrackdaysWeb.Controllers.Helpers

  def user_not_found(_) do
    %{error: true, message: "Not found"}
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
end
