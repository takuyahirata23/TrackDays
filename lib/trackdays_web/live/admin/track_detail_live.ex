defmodule TrackdaysWeb.Admin.TrackDetailLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Facility

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <div>
        <h1 class="font-bold text-xl mb-6"><%= @track.name %></h1>
        <h2 :if={@track.description}><%= @track.description %></h2>
      </div>
      <div :if={!Enum.empty?(@track.layouts)}>
        <.card margin_bottom={false}>
          <ul class="flex flex-col gap-y-4">
            <li :for={layout <- @track.layouts}>
              <%= layout.name %>
            </li>
          </ul>
        </.card>
      </div>
    </div>
    """
  end

  def mount(%{"id" => track_id}, _, socket) do
    track = Facility.get_track(track_id)
    IO.inspect(track)
    {:ok, assign(socket, track: track)}
  end
end
