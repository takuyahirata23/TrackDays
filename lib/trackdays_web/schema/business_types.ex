defmodule TrackdaysWeb.Schema.BusinessTypes do
  use Absinthe.Schema.Notation

  alias TrackdaysWeb.Resolvers

  object :organization do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :trackdays_registration_url, :string
    field :homepage_url, :string
  end

  object :business_queries do
    @desc "Get a organization"
    field :organization, non_null(:organization) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Business.get_organization/3)
    end
  end
end
