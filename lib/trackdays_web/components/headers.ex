defmodule TrackdaysWeb.Headers do
  use Phoenix.Component
  use TrackdaysWeb, :verified_routes
  import TrackdaysWeb.CoreComponents, only: [icon: 1]

  alias Phoenix.LiveView.JS

  def admin(assigns) do
    ~H"""
    <header class="max-w-6xl w-11/12 mx-auto mb-4">
      <div class="flex justify-between items-center py-4">
        <h1 class="text-xl font-bold">Trackdays Admin</h1>
        <button phx-click={toggle_mobile_menu()} class="p-1" id="open">
          <.icon name="hero-bars-3" class="w-6 h-6" />
        </button>
        <button phx-click={toggle_mobile_menu()} class="p-1 hidden" id="close">
          <.icon name="hero-x-mark" class="w-6 h-6" />
        </button>
      </div>
      <div class="relative">
        <div id="backdrop" class="z-10 fixed h-screen inset-x-0 bg-bg-secondary opacity-50 hidden" />
        <nav
          id="mobile-navigation"
          class="z-20 fixed bg-bg-secondary h-screen right-0  drop-shadow-md hidden w-2/3 p-8"
        >
          <ul class="flex flex-col gap-y-4">
            <li>
              <.link navigate={~p"/admin/dashboard"}>Dashbaord</.link>
            </li>
            <li>
              <.link navigate={~p"/admin/vehicle/makes"}>Makes</.link>
            </li>
            <li>
              <.link navigate={~p"/admin/park/facilities"}>Facilities</.link>
            </li>
            <li>
              <.link navigate={~p"/admin/log_in"}>Log in</.link>
            </li>
          </ul>
        </nav>
      </div>
    </header>
    """
  end

  def toggle_mobile_menu do
    JS.toggle(
      to: "#mobile-navigation",
      in: {"ease-in-out duration-300", "translate-x-full", "translate-x-0"},
      out: {"ease-in-out duration-300", "translate-x-0", "translate-x-full"},
      time: 300
    )
    |> JS.toggle(to: "#open")
    |> JS.toggle(to: "#close")
    |> JS.toggle(to: "#backdrop", in: "fade-in", out: "fade-out")
  end
end
