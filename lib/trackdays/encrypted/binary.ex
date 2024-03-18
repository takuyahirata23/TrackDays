defmodule Trackdays.Encrypted.Binary do
  use Cloak.Ecto.Binary, vault: Trackdays.Vault
end
