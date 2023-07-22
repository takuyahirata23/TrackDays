defmodule TrackdaysWeb.Schema.VehicleTypes do
  use Absinthe.Schema.Notation

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Trackdays.Vehicle
  alias TrackdaysWeb.Resolvers

  object :make do
    field :id, non_null(:id)
    field :name, non_null(:string)
    # field :models, non_null(list_of(:model)), resolve: dataloader(Vehicle)
  end

  object :model do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :vehicle_queries do
    @desc "Get makes"
    field :makes, list_of(non_null(:make)) do
      resolve(&Resolvers.Vehicle.get_makes/3)
    end

    @desc "Get models of a make"
    field :models, list_of(non_null(:model)) do
      arg(:make_id, non_null(:id))
      resolve(&Resolvers.Vehicle.get_models/3)
    end
  end
end
