class RiskMeasurement::StandardMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::StandardRisk'
end
