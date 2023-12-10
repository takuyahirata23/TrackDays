defmodule TrackdaysWeb.Resolvers.Accounts do
  alias Trackdays.Accounts

  def get_user(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_groups(_, _, _) do
    {:ok, Accounts.get_groups()}
  end
end
