defmodule TrackdaysWeb.Admin.FacilityDetailLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Park
  alias Trackdays.Park.Track

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <div>
        <h1 class="font-bold text-xl mb-6"><%= @facility.name %></h1>
        <h2 :if={@facility.description}><%= @facility.description %></h2>
      </div>
      <div>
        <.card title="Add Track">
          <.simple_form for={@track_form} phx-submit="add-track">
            <div class="flex flex-col gap-y-4 mb-6">
              <.input field={@track_form[:name]} type="text" label="Name" required />
              <.input field={@track_form[:length]} type="text" label="Length" required />
            </div>
            <:actions>
              <.button phx-disable-with="Registering..." class="w-full">
                Save track <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </.card>
      </div>
      <div :if={!Enum.empty?(@facility.tracks)}>
        <.card margin_bottom={false}>
          <ul class="flex flex-col gap-y-4">
            <li :for={track <- @facility.tracks}>
              <%= track.name %>
            </li>
          </ul>
        </.card>
      </div>
    </div>
    """
  end

  def mount(%{"id" => facility_id}, _, socket) do
    facility = Park.get_facility_and_tracks(facility_id)
    track_form = Track.changeset(%Track{}) |> to_form()

    {:ok, assign(socket, facility: facility, track_form: track_form)}
  end

  def handle_event("add-track", %{"track" => attrs}, socket) do
    case Park.save_track(attrs, socket.assigns.facility) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket |> put_flash(:error, "Failed") |> assign(track_form: to_form(changeset))}

      {:ok, track} ->
        track_form = Track.changeset(%Track{}) |> to_form()

        tracks =
          List.insert_at(
            socket.assigns.facility.tracks,
            length(socket.assigns.facility.tracks),
            track
          )

        facility = Map.replace(socket.assigns.facility, :tracks, tracks)

        {:noreply,
         socket
         |> put_flash(:info, "Saved track")
         |> assign(track_form: track_form, facility: facility)}
    end
  end
end
