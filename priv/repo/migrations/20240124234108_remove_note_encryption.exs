defmodule Trackdays.Repo.Migrations.RemoveNoteEncryption do
  use Ecto.Migration

  def change do
     alter table(:trackday_notes) do
       remove :note
     end

     rename table(:trackday_notes), :encrypted_note, to: :note
  end
end
