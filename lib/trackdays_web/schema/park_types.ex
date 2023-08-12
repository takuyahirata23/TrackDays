defmodule TrackdaysWeb.Schema.ParkTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Trackdays.Park
  alias TrackdaysWeb.Resolvers

  object :facility do
    field :id, non_null(:id)
    field :name, non_null(:id)
    field :description, :string
    field :tracks, list_of(non_null(:track)), resolve: dataloader(Park)
  end

  object :track do
    field :id, non_null(:id)
    field :name, non_null(:id)
    field :length, non_null(:float)
    field :facility, non_null(:facility), resolve: dataloader(Park)
  end

  object :park_queries do
    @desc "List all facilities"
    field :facilities, list_of(non_null(:facility)) do
      resolve(&Resolvers.Park.get_facilities/3)
    end

    @desc "Get a facility"
    field :facility, non_null(:facility) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Park.get_facility/3)
    end

    @desc "Get tracks"
    field :tracks, list_of(non_null(:track)) do
      arg(:facility_id, non_null(:id))
      resolve(&Resolvers.Park.get_tracks/3)
    end
  end
end
