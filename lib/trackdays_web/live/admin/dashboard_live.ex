defmodule TrackdaysWeb.Admin.DashboardLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Accounts
  alias Trackdays.Event

  def render(assigns) do
    ~H"""
    <div>
      <.card class="grid gap-y-4">
        <p class="text-center font-bold text-2xl">Numbers</p>
        <div class="grid gap-y-4 md:grid-cols-2 gap-4">
          <.card variant="secondary" class="flex flex-col items-center gap-y-4">
            <p class="font-bold">Total Users</p>
            <span>
              <%= @total_users %>
            </span>
          </.card>
          <.card variant="secondary" class="flex flex-col items-center gap-y-4">
            <p class="font-bold">Total Trackdays This Year</p>
            <span>
              <%= @total_trackdays_this_year %>
            </span>
          </.card>
        </div>
      </.card>
    </div>
    """
  end

  def mount(_, _, socket) do
    total_users = Accounts.count_users()
    total_trackdays_this_year = Event.count_trackdays_this_year()

    {:ok,
     assign(socket, total_users: total_users, total_trackdays_this_year: total_trackdays_this_year)}
  end
end
