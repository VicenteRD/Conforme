class Asset::Maintenance
  include Mongoid::Document

  embedded_in :asset

  field :ma_at, as: :maintained_at, type: DateTime

  field :mtv, as: :motive, type: String
  field :rst, as: :result, type: String
end
