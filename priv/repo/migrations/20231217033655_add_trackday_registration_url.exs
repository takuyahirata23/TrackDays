defmodule Trackdays.Repo.Migrations.AddTrackdayRegistrationUrl do
  use Ecto.Migration

  def change do
     alter table(:organizations) do
       add :homepage_url, :string
       modify :trackdays_registration_url, :string, null: false, from: {:string, null: true}
     end

     alter table(:trackdays) do
       add :trackdays_registration_url, :string
     end
  end
end
