class Asset::Calibration
  include Mongoid::Document

  embedded_in :asset

  field :ca_at, as: :calibrated_at, type: DateTime

  field :mtv, as: :motive, type: String
  field :rst, as: :result, type: String
end
