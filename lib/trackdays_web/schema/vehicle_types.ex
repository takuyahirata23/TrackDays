defmodule TrackdaysWeb.Schema.VehicleTypes do
  use Absinthe.Schema.Notation

  alias TrackdaysWeb.Resolvers.Vehicle

  object :make do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :vehicle_queries do
    @desc "Get makes"
    field :makes, list_of(non_null(:make)) do
      resolve(&Vehicle.get_makes/3)
    end
  end
end
