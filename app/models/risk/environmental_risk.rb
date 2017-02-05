class Risk::EnvironmentalRisk < Risk
  embeds_many :measurements, class_name: 'RiskMeasurement::EnvironmentalMeasurement'

  field :asp, as: :aspect, type: String
  field :imp, as: :impact, type: String

end
