defmodule TrackdaysWeb.UserSessionJSON do
  def user_not_found(_) do
    %{error: true, message: "Not found"}
  end

  def login(%{user: user, token: token}) do
    %{error: false, message: "User found", user: user, token: token}
  end
end
