class Settings::RiskSettings
  include Mongoid::Document

  field :margin, type: Float

  field :op_safe, as: :operational_threshold, type: Float
  field :op_opts, as: :operational_options, type: Hash

  field :env_safe, as: :environmental_threshold, type: Float
  field :env_opts, as: :environmental_options, type: Hash
end
