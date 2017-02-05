class RiskMeasurement::LawMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::LawRisk'
end
