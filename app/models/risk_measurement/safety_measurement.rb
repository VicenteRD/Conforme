class RiskMeasurement::SafetyMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::SafetyRisk'
end