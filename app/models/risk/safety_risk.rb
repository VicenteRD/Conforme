class Risk::SafetyRisk
  include Mongoid::Document

  validates_presence_of :position_id

  embeds_many :measurements, class_name: 'RiskMeasurement::SafetyMeasurement'

  field :pos_id, as: :position_id, type: BSON::ObjectId # => Position
  field :cond, as: :condition, type: String
  field :ag, as: :agent, type: Integer
  field :cons, as: :consequence, type: String

  embeds_many :measurements, class_name: 'RiskMeasurement::SafetyMeasurement'
end
