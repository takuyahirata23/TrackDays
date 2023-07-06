defmodule TrackdaysWeb.Admin.MotorcycleLive do
  use TrackdaysWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>mototrycles</div>
    """
  end

  def mount(_, _, socket) do
    {:ok, socket}
  end
end
