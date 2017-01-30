class Settings::RiskSettings
  include Mongoid::Document

  field :operational_threshold, type: Float
  field :margin, type: Float
end
