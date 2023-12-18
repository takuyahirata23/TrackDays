defmodule TrackdaysWeb.Schema.EventTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Trackdays.{Park, Vehicle, Business}

  alias TrackdaysWeb.Resolvers

  object :trackday_note do
    field :id, non_null(:id)
    field :lap_time, :integer
    field :date, non_null(:string)
    field :note, :string
    field :track, non_null(:track), resolve: dataloader(Park)
    field :motorcycle, non_null(:motorcycle), resolve: dataloader(Vehicle)
  end

  object :trackday do
    field :id, non_null(:id)
    field :date, non_null(:string)
    field :price, non_null(:float)
    field :description, :string
    field :trackdays_registration_url, :string
    field :track, non_null(:track), resolve: dataloader(Park)
    field :organization, non_null(:organization), resolve: dataloader(Business)
  end

  input_object :get_events_by_month_input do
    field :month, non_null(:integer)
    field :year, non_null(:integer)
  end

  input_object :save_trackday_note_input do
    field :lap_time, :integer
    field :date, non_null(:string)
    field :track_id, non_null(:id)
    field :motorcycle_id, non_null(:id)
    field :note, :string
  end

  input_object :update_trackday_note_input do
    field :id, non_null(:id)
    field :lap_time, :integer
    field :track_id, :id
    field :motorcycle_id, :id
    field :note, :string
  end

  object :event_queries do
    @desc "Get trackday notes"
    field :trackday_notes, list_of(non_null(:trackday_note)) do
      resolve(&Resolvers.Event.get_trackday_notes/3)
    end

    @desc "Get trackday notes by month"
    field :trackday_notes_by_month, list_of(non_null(:trackday_note)) do
      arg(:get_events_by_month_input, non_null(:get_events_by_month_input))
      resolve(&Resolvers.Event.get_trackday_notes_by_month/3)
    end

    @desc "Get trackday note by trackday id"
    field :trackday_note, non_null(:trackday_note) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Event.get_trackday_note_by_id/3)
    end

    @desc "Get best laps for each track"
    field :best_lap_for_each_track, list_of(:trackday_note) do
      resolve(&Resolvers.Event.get_best_lap_for_each_track/3)
    end

    @desc "Get events by month"
    field :trackdays_by_month, non_null(list_of(:trackday)) do
      arg(:get_events_by_month_input, non_null(:get_events_by_month_input))
      resolve(&Resolvers.Event.get_trackdays_by_month/3)
    end

    @desc "Get trackday detail"
    field :trackday, non_null(:trackday) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Event.get_trackday/3)
    end
  end

  object :event_mutations do
    @desc "Save trackday note"
    field :save_trackday_note, non_null(:trackday_note) do
      arg(:save_trackday_note_input, non_null(:save_trackday_note_input))
      resolve(&Resolvers.Event.save_trackday_note/3)
    end

    @desc "Delete trackday note"
    field :delete_trackday_note, non_null(:trackday_note) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Event.delete_trackday_note/3)
    end

    @desc "Update trackday note"
    field :update_trackday_note, non_null(:trackday_note) do
      arg(:update_trackday_note_input, non_null(:update_trackday_note_input))
      resolve(&Resolvers.Event.update_trackday_note/3)
    end
  end
end
