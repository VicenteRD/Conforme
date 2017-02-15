class RiskMeasurement::SafetyMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::SafetyRisk'

  validates_presence_of :probability, :impact

  field :pbb, as: :probability, type: Float

  field :imp, as: :impact, type: Integer

  def calculate_magnitude
    self.magnitude = self.probability * self.impact

    super
  end
end
