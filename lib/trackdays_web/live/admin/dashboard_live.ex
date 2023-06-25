defmodule TrackdaysWeb.Admin.DashboardLive do
  use TrackdaysWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>here</div>
    """
  end

  def mount(_, _, socket) do
    {:ok, socket}
  end
end
