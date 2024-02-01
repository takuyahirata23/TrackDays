defmodule TrackdaysWeb.Admin.OrganizationTrackdayEdit do
  use TrackdaysWeb, :live_view

  alias Trackdays.{Event, Business}
  alias Trackdays.Event.Trackday

  def render(assigns) do
    ~H"""
    <.card title="Update Trackday">
      <.simple_form for={@trackday_form} phx-submit="update">
        <div class="flex flex-col gap-y-4 mb-6">
          <.input
            field={@trackday_form[:organization_id]}
            type="select"
            label="Organization"
            options={@organization_options}
            prompt="Select organization"
            required
          />
          <.input
            field={@trackday_form[:track_id]}
            type="select"
            label="Track"
            options={@track_options}
            prompt="Select track"
            required
          />
          <.input
            field={@trackday_form[:start_datetime]}
            type="datetime-local"
            label="Start date time"
            required
          />
          <.input
            field={@trackday_form[:end_datetime]}
            type="datetime-local"
            label="End date time"
            required
          />
          <.input field={@trackday_form[:price]} type="text" label="Price" required />
          <.input
            field={@trackday_form[:trackdays_registration_url]}
            type="text"
            label="Registration URL"
          />
          <.input field={@trackday_form[:description]} type="textarea" label="description" />
        </div>
        <:actions>
          <.button phx-disable-with="Registering..." class="w-full">
            Update <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </.card>
    """
  end

  def mount(%{"id" => organization_id, "trackday_id" => trackday_id}, _, socket) do
    trackday_form = Event.get_trackday_by_id(trackday_id) |> Trackday.changeset() |> to_form()
    organization_options = Business.get_organization_options_for_select()
    track_options = Business.get_track_options_for_select() |> transform_to_options

    {:ok,
     assign(socket,
       trackday_id: trackday_id,
       trackday_form: trackday_form,
       organization_options: organization_options,
       track_options: track_options,
       organization_id: organization_id
     )}
  end

  def handle_event("update", %{"trackday" => attrs}, socket) do
    case Event.update_trackday(socket.assigns.trackday_id, attrs) do
      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Something went wrong")
         |> assign(trackday_form: to_form(changeset))}

      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Updated")
         |> push_navigate(to: ~p"/admin/business/organizations/#{socket.assigns.organization_id}")}
    end
  end

  defp transform_to_options(track_with_facility) do
    track_with_facility
    |> Enum.map(fn x -> {"#{x.track}(#{x.facility})", x.id} end)
  end
end
