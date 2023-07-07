defmodule TrackdaysWeb.Schema.Schema do
  use Absinthe.Schema

  alias TrackdaysWeb.Schema

  import_types(Schema.AccountsTypes)
  import_types(Schema.VehicleTypes)

  query do
    import_fields(:user_queries)
    import_fields(:vehicle_queries)
  end
end
