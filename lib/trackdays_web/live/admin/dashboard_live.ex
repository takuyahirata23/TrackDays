defmodule TrackdaysWeb.Admin.DashboardLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Accounts

  def render(assigns) do
    ~H"""
    <div>
      <.card class="grid gap-y-4">
        <p class="text-center font-bold text-2xl">Numbers</p>
        <.card variant="secondary" class="flex flex-col items-center gap-y-4">
          <p class="font-bold">Total Users</p>
          <span>
            <%= @total_users %>
          </span>
        </.card>
      </.card>
    </div>
    """
  end

  def mount(_, _, socket) do
    total_users = Accounts.count_users()

    {:ok, assign(socket, total_users: total_users)}
  end
end
