defmodule TrackdaysWeb.Admin.MakeDetailLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Vehicle
  alias Trackdays.Vehicle.Model

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <.card title="Add Make">
        <.simple_form for={@model_form} phx-submit="add-model">
          <.input field={@model_form[:name]} type="text" label="Name" required />
          <:actions>
            <.button phx-disable-with="Registering..." class="w-full">
              Register model <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </.card>
      <.card title={@make.name}>
        <ul>
          <li :for={model <- @make.models}>
            <span><%= model.name %></span>
          </li>
        </ul>
      </.card>
    </div>
    """
  end

  def mount(%{"id" => make_id}, _, socket) do
    make = Vehicle.get_make_detail(make_id)
    model_form = Model.changeset(%Model{}) |> to_form()

    {:ok, assign(socket, make: make, model_form: model_form)}
  end

  def handle_event("add-model", %{"model" => attrs}, socket) do
    case Vehicle.save_model(attrs, socket.assigns.make) do
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        {:noreply,
         socket
         |> put_flash(:error, "Problem adding model")
         |> assign(model_form: to_form(changeset))}

      {:ok, _model} ->
        model_form = Model.changeset(%Model{}) |> to_form()

        # TODO: use append to show new models 

        {:noreply,
         socket
         |> put_flash(:info, "Added model")
         |> assign(model_form: model_form)}
    end
  end
end
