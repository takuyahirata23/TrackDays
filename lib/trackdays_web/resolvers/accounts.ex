defmodule TrackdaysWeb.Resolvers.Accounts do
  alias Trackdays.Accounts

  def get_user(_, _, %{context: %{user_id: user_id}}) do
    {:ok, Accounts.get_user_by_id(user_id)}
  end
end
