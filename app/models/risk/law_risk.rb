class Risk::LawRisk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::LawMeasurement'
end
