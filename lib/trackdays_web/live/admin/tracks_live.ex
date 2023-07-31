defmodule TrackdaysWeb.Admin.TracksLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Facility
  alias Trackdays.Facility.Track

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="font-bold text-xl mb-8">Tracks</h1>
      <div class="flex flex-col gap-y-8">
        <.card title="Add Track">
          <.simple_form for={@track_form} phx-submit="add-track">
            <div class="flex flex-col gap-y-4 mb-6">
              <.input field={@track_form[:name]} type="text" label="Name" required />
              <.input field={@track_form[:description]} type="textarea" label="Description" />
            </div>
            <:actions>
              <.button phx-disable-with="Registering..." class="w-full">
                Register track <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </.card>

        <.card margin_bottom={false}>
          <ul class="flex flex-col gap-y-4">
            <li :for={track <- @tracks}>
              <.link navigate={~p"/admin/facility/tracks/#{track.id}"}>
                <%= track.name %>
              </.link>
            </li>
          </ul>
        </.card>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    track_form = Track.changeset(%Track{}) |> to_form()
    tracks = Facility.get_tracks()
    {:ok, assign(socket, track_form: track_form, tracks: tracks)}
  end

  def handle_event("add-track", %{"track" => attrs}, socket) do
    case Facility.save_track(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        track_form = to_form(changeset)

        {:noreply,
         socket |> put_flash(:error, "Problem saving track") |> assign(track_form: track_form)}

      {:ok, track} ->
        track_form = Track.changeset(%Track{}) |> to_form()

        # TODO: use append to show new tracks
        tracks = List.insert_at(socket.assigns.tracks, length(socket.assigns.tracks), track)

        {:noreply,
         socket
         |> put_flash(:info, "Saved track")
         |> assign(track_form: track_form, tracks: tracks)}
    end
  end
end
