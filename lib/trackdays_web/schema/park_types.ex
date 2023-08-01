defmodule TrackdaysWeb.Schema.ParkTypes do
  use Absinthe.Schema.Notation

  alias TrackdaysWeb.Resolvers

  object :facility do
    field :id, non_null(:id)
    field :name, non_null(:id)
    field :description, :string
  end

  object :track do
    field :id, non_null(:id)
    field :name, non_null(:id)
  end

  object :park_queries do
    @desc "List all facilities"
    field :facilities, list_of(non_null(:facility)) do
      resolve(&Resolvers.Park.get_facilities/3)
    end
  end
end
