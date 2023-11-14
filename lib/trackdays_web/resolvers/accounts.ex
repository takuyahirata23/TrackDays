defmodule TrackdaysWeb.Resolvers.Accounts do
  alias Trackdays.Accounts

  def get_user(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def delete_user_account(_, _, %{context: %{current_user: current_user}}) do
    Accounts.delete_user_account(current_user)
  end
end
