defmodule TrackdaysWeb.Admin.RegisterTrackdayLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Business
  alias Trackdays.Event.Trackday

  def render(assigns) do
    ~H"""
    <div>
      <.card title="Register Trackday">
        <.simple_form for={@trackday_form} phx-submit="register-trackday">
          <div class="flex flex-col gap-y-4 mb-6">
            <.input
              field={@trackday_form[:organization_id]}
              type="select"
              label="Organization"
              options={@organization_options}
              value="nil"
              prompt="Select organization"
              required
            />
            <.input
              field={@trackday_form[:track_id]}
              type="select"
              label="Track"
              options={@track_options}
              value="nil"
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
              Save track <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </.card>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    trackday_form = Trackday.changeset(%Trackday{}) |> to_form()

    organization_options = Business.get_organization_options_for_select()
    track_options = Business.get_track_options_for_select() |> transform_to_options

    {:ok,
     assign(socket,
       trackday_form: trackday_form,
       organization_options: organization_options,
       track_options: track_options
     )}
  end

  def handle_event("register-trackday", %{"trackday" => attrs}, socket) do
    case Business.register_trackday(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        trackday_form = to_form(changeset)

        {:noreply,
         socket
         |> put_flash(:error, "Error registering trackday")
         |> assign(trackday_form: trackday_form)}

      {:ok, _} ->
        trackday_form = Trackday.changeset(%Trackday{}) |> to_form()

        {:noreply,
         socket
         |> put_flash(:info, "Registered new trackday")
         |> assign(trackday_form: trackday_form)}
    end
  end

  defp transform_to_options(track_with_facility) do
    track_with_facility
    |> Enum.map(fn x -> {"#{x.track}(#{x.facility})", x.id} end)
  end
end
