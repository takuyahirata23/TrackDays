defmodule TrackdaysWeb.Admin.TrackDetailLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Facility
  alias Trackdays.Facility.Layout

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <div>
        <h1 class="font-bold text-xl mb-6"><%= @track.name %></h1>
        <h2 :if={@track.description}><%= @track.description %></h2>
      </div>
      <div>
        <.card title="Add Layout">
          <.simple_form for={@layout_form} phx-submit="add-layout">
            <div class="flex flex-col gap-y-4 mb-6">
              <.input field={@layout_form[:name]} type="text" label="Name" required />
              <.input field={@layout_form[:length]} type="text" label="Length" required />
            </div>
            <:actions>
              <.button phx-disable-with="Registering..." class="w-full">
                Save layout <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </.card>
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
    layout_form = Layout.changeset(%Layout{}) |> to_form()

    {:ok, assign(socket, track: track, layout_form: layout_form)}
  end

  def handle_event("add-layout", %{"layout" => attrs}, socket) do
    case Facility.save_layout(attrs, socket.assigns.track) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket |> put_flash(:error, "Failed") |> assign(layout_form: to_form(changeset))}

      {:ok, layout} ->
        layout_form = Layout.changeset(%Layout{}) |> to_form()

        layouts =
          List.insert_at(
            socket.assigns.tracks.layout,
            length(socket.assigns.tracks.layout),
            layout
          )

        tracks = Map.replace(socket.assigns.tracks, :layouts, layouts)

        {:noreply,
         socket
         |> put_flash(:info, "Saved layout")
         |> assign(layout_form: layout_form, tracks: tracks)}
    end
  end
end
