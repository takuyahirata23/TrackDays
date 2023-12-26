# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Trackdays.Repo.insert!(%Trackdays.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#

{:ok, yamaha} = Trackdays.Vehicle.save_make(%{"name" => "YAMAHA"})
{:ok, honda} = Trackdays.Vehicle.save_make(%{"name" => "HONDA"})

Trackdays.Vehicle.save_model(
  %{
    "name" => "YZF-R1"
  },
  yamaha
)

Trackdays.Vehicle.save_model(
  %{
    "name" => "YZF-R6"
  },
  yamaha
)

Trackdays.Vehicle.save_model(
  %{
    "name" => "YZF-R7"
  },
  yamaha
)

Trackdays.Vehicle.save_model(
  %{
    "name" => "CBR1000RR-R Fireblade SP"
  },
  honda
)

Trackdays.Accounts.create_group(%{"name" => "Novice"})
Trackdays.Accounts.create_group(%{"name" => "Intermediate"})
Trackdays.Accounts.create_group(%{"name" => "Expert"})
