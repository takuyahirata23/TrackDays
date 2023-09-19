defmodule TrackdaysWeb.Schema.EventTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Trackdays.{Park, Vehicle}

  alias TrackdaysWeb.Resolvers

  object :trackday do
    field :id, non_null(:id)
    field :lap_time, :integer
    field :date, non_null(:string)
    field :note, :string
    field :track, non_null(:track), resolve: dataloader(Park)
    field :motorcycle, non_null(:motorcycle), resolve: dataloader(Vehicle)
  end

  input_object :get_trackdays_by_month_input do
    field :month, non_null(:integer)
    field :year, non_null(:integer)
  end

  input_object :save_trackday_input do
    field :lap_time, non_null(:integer)
    field :date, non_null(:string)
    field :track_id, non_null(:id)
    field :motorcycle_id, non_null(:id)
    field :note, non_null(:string)
  end

  object :event_queries do
    @desc "Get trackdays"
    field :trackdays, list_of(non_null(:trackday)) do
      resolve(&Resolvers.Event.get_trackdays/3)
    end

    @desc "Get trackdays by month"
    field :trackdays_by_month, list_of(non_null(:trackday)) do
      arg(:get_trackdays_by_month_input, non_null(:get_trackdays_by_month_input))
      resolve(&Resolvers.Event.get_trackday_by_month/3)
    end

    @desc "Get trackday by trackday id"
    field :trackday, non_null(:trackday) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Event.get_trackday_by_trackday_id/3)
    end
  end

  object :event_mutations do
    @desc "Save trackday"
    field :save_trackday, non_null(:trackday) do
      arg(:save_trackday_input, non_null(:save_trackday_input))
      resolve(&Resolvers.Event.save_trackday/3)
    end
  end
end
