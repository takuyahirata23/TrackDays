defmodule TrackdaysWeb.Helpers.Datetime do
  def format_date(date) do
    Calendar.strftime(date, "%y-%m-%d %I:%M %p")
  end
end

