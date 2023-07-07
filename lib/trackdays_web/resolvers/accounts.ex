defmodule TrackdaysWeb.Resolvers.Accounts do
  def get_user(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end
end
