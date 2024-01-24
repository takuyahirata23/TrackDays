Trackdays.Repo.all(Trackdays.Event.TrackdayNote)
|> Enum.map(fn tn ->
  Ecto.Changeset.change(tn, encrypted_note: tn.note)
  |> Trackdays.Repo.update!()
end)
