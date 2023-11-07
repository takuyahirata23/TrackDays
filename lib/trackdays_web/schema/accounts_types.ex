defmodule TrackdaysWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  alias TrackdaysWeb.Resolvers.Accounts

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :image_url, (:string)
  end

  object :accounts_queries do
    @desc "Get current user"
    field :user, non_null(:user) do
      resolve(&Accounts.get_user/3)
    end
  end
end
