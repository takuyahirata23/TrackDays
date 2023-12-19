defmodule TrackdaysWeb.Resolvers.Accounts do
  alias Trackdays.Accounts

  def get_user(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_groups(_, _, _) do
    {:ok, Accounts.get_groups()}
  end

  def update_group(_, %{group_id: group_id}, %{context: %{current_user: current_user}}) do
    case Accounts.update_group(current_user, group_id) do
      {:error, _} -> {:error, message: "Updating group failed"}
      {:ok, user} -> {:ok, user}
    end
  end
end
