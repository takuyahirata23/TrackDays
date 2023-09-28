defmodule TrackdaysWeb.Router do
  use TrackdaysWeb, :router

  import TrackdaysWeb.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TrackdaysWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :set_user do
    plug TrackdaysWeb.Plugs.SetUser
  end

  pipeline :require_user do
    plug TrackdaysWeb.Plugs.RequireUser
  end

  scope "/", TrackdaysWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrackdaysWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trackdays, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TrackdaysWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Mix.env() in [:dev] do
    scope "/" do
      pipe_through [:api, :set_user]
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: TrackdaysWeb.Schema.Schema
    end
  end

  scope "/" do
    pipe_through [:api, :set_user, :require_user]
    forward "/api/graphql", Absinthe.Plug, schema: TrackdaysWeb.Schema.Schema
  end

  scope "/auth", TrackdaysWeb do
    pipe_through [:api]

    post "/login", UserSessionController, :login
    post "/register", UserSessionController, :register
    post "/verify/:id", UserSessionController, :verify
  end

  scope("/accounts", TrackdaysWeb) do
    pipe_through [:browser]
    get "/verification_success", AccountController, :verification_success
    get "/verification_fail", AccountController, :verification_fail
  end

  scope "/admin", TrackdaysWeb do
    pipe_through [:browser]

    live_session :unauthorized_admin,
      layout: {TrackdaysWeb.Layouts, :admin} do
      live "/log_in", Admin.LoginLive
    end

    post "/log_in", AdminSessionController, :create
  end

  scope "/admin", TrackdaysWeb do
    pipe_through [:browser, :require_admin_user]

    live_session :admin,
      layout: {TrackdaysWeb.Layouts, :admin},
      on_mount: [
        {TrackdaysWeb.Auth, :ensure_admin}
      ] do
      live "/dashboard", Admin.DashboardLive
      live "/vehicle/makes", Admin.MakesLive
      live "/vehicle/makes/:id", Admin.MakeDetailLive
      live "/park/facilities", Admin.FacilitiesLive
      live "/park/facilities/:id", Admin.FacilityDetailLive
    end
  end
end
