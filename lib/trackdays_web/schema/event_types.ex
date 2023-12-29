defmodule TrackdaysWeb.Schema.EventTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Trackdays.{Park, Vehicle, Business, Event, Accounts}

  alias TrackdaysWeb.Resolvers

  object :trackday_note do
    field :id, non_null(:id)
    field :lap_time, :integer
    field :date, non_null(:string)
    field :note, :string
    field :track, non_null(:track), resolve: dataloader(Park)
    field :motorcycle, non_null(:motorcycle), resolve: dataloader(Vehicle)
    field :user, non_null(:user), resolve: dataloader(Accounts)
  end

  object :trackday do
    field :id, non_null(:id)
    field :start_datetime, non_null(:string)
    field :end_datetime, non_null(:string)
    field :price, non_null(:float)
    field :description, :string
    field :trackdays_registration_url, :string
    field :track, non_null(:track), resolve: dataloader(Park)
    field :organization, non_null(:organization), resolve: dataloader(Business)
  end

  object :user_trackday_calendar do
    field :id, non_null(:id)
    field :calendar_id, non_null(:id)
    field :event_id, non_null(:id)
    field :trackday, non_null(:trackday), resolve: dataloader(Event)
  end

  # object :leader_board do
  #   field :time, non_null(:integer)
  #   field :user, non_null(:user)
  #   field :motorcycle, non_null(:motorcycle)
  # end

  object :tracks_with_leaderboard do
    field :id, non_null(:id)
    field :name, non_null(:id)
    field :length, non_null(:float)
    field :trackday_notes, non_null(list_of(:trackday_note))
  end

  # object :facility_with_leader_board do
  #   field :id, non_null(:id)
  #   field :name, non_null(:string)
  #   field :description, :string
  #   field :tracks, non_null(list_of(:tracks_for_leaderboard))
  # end

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

  input_object :save_user_trackday_calendar_input do
    field :calendar_id, non_null(:id)
    field :event_id, non_null(:id)
    field :trackday_id, :id
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

    @desc "Get specific user trackday calendar"
    field :user_trackday_calendar, :user_trackday_calendar do
      arg(:trackday_id, non_null(:id))
      resolve(&Resolvers.Event.get_user_trackday_calendar/3)
    end

    @desc "Get upcoming trackdays"
    field :upcoming_trackdays, list_of(:trackday) do
      resolve(&Resolvers.Event.get_upcoming_trackdays/3)
    end

    @desc "Get leaderboard for facility"
    field :tracks_with_leaderboard, list_of(:tracks_with_leaderboard) do
      arg(:facility_id, non_null(:id))
      resolve(&Resolvers.Event.get_facility_leaderboard/3)
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

    @desc "Save user trackday calendar history"
    field :save_user_trackday_calendar, non_null(:user_trackday_calendar) do
      arg(:save_user_trackday_calendar_input, non_null(:save_user_trackday_calendar_input))
      resolve(&Resolvers.Event.save_user_trackday_calendar/3)
    end

    @desc "Delete user trackday calendar history"
    field :delete_user_trackday_calendar, non_null(:user_trackday_calendar) do
      arg(:trackday_id, non_null(:id))
      resolve(&Resolvers.Event.delete_user_trackday_calendar/3)
    end
  end
end
