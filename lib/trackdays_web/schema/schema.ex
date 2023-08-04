defmodule TrackdaysWeb.Schema.Schema do
  use Absinthe.Schema

  alias TrackdaysWeb.Schema

  alias Trackdays.{Vehicle, Park}

  import_types(Schema.AccountsTypes)
  import_types(Schema.VehicleTypes)
  import_types(Schema.ParkTypes)
  import_types(Schema.EventTypes)

  query do
    import_fields(:accounts_queries)
    import_fields(:vehicle_queries)
    import_fields(:park_queries)
    import_fields(:event_queries)
  end

  mutation do
    import_fields(:vehicle_mutations)
    import_fields(:event_mutations)
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(Trackdays.Repo)

    loader =
      Dataloader.new()
      |> Dataloader.add_source(Vehicle, Vehicle.datasource())
      |> Dataloader.add_source(Park, source)

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
