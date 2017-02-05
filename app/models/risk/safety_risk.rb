class Risk::SafetyRisk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::SafetyMeasurement'
end
