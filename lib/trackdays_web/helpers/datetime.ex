defmodule TrackdaysWeb.Helpers.Datetime do
  def format_datetime(date) do
    Calendar.strftime(date, "%y-%m-%d %I:%M %p")
  end

  def format_date(date) do
    Calendar.strftime(date, "%y-%m-%d")
  end
end

