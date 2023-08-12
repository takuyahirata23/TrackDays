defmodule TrackdaysWeb.Schema.VehicleTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  # alias Trackdays.Vehicle
  alias TrackdaysWeb.Resolvers
  alias Trackdays.Vehicle

  object :make do
    field :id, non_null(:id)
    field :name, non_null(:string)
    # field :models, non_null(list_of(:model)), resolve: dataloader(Vehicle)
  end

  object :model do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :make, non_null(:make), resolve: dataloader(Vehicle)
  end

  object :motorcycle do
    field :id, non_null(:id)
    field :year, non_null(:integer)
    field :model, non_null(:model), resolve: dataloader(Vehicle)
  end

  input_object :register_motorcycle_input do
    field :model_id, non_null(:id)
    field :year, non_null(:integer)
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

    @desc "Get all motorcycles"
    field :motorcycles, list_of(non_null(:motorcycle)) do
      resolve(&Resolvers.Vehicle.get_motorcycles/3)
    end
  end

  object :vehicle_mutations do
    @desc "Register motorcycle"
    field :register_motorcycle, non_null(:motorcycle) do
      arg(:register_motorcycle_input, non_null(:register_motorcycle_input))
      resolve(&Resolvers.Vehicle.register_motorcycle/3)
    end
  end
end
