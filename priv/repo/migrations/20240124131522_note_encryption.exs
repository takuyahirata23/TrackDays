defmodule Trackdays.Repo.Migrations.NoteEncryption do
  use Ecto.Migration

  def change do
    alter table(:trackday_notes) do
       add :encrypted_note, :binary
    end
  end
end
