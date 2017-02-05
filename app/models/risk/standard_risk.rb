class Risk::StandardRisk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::StandardMeasurement'
end
