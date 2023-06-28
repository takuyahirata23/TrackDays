defmodule TrackdaysWeb.Schema.Schema do
  use Absinthe.Schema

  alias TrackdaysWeb.Schema

  import_types(Schema.AccountsTypes)

  query do
    import_fields(:user_queries)
  end
end
