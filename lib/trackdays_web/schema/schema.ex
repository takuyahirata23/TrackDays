defmodule TrackdaysWeb.Schema.Schema do
  use Absinthe.Schema

  alias TrackdaysWeb.Schema

  alias Trackdays.Vehicle

  import_types(Schema.AccountsTypes)
  import_types(Schema.VehicleTypes)

  query do
    import_fields(:accounts_queries)
    import_fields(:vehicle_queries)
  end

  mutation do
    import_fields(:vehicle_mutations)
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(Trackdays.Repo)

    loader =
      Dataloader.new()
      |> Dataloader.add_source(Vehicle, source)

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
