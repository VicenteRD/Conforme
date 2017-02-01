class Settings::RiskSettings
  include Mongoid::Document

  field :margin, type: Float


  field :op_safe, as: :operational_threshold, type: Float

  field :op_opt_hash, as: :operational_impact_options, type: Hash
end
