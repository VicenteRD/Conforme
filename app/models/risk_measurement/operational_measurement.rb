class RiskMeasurement::OperationalMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::OperationalRisk'

  validates_presence_of :probability, :impact

  field :pbb, as: :probability, type: Float

  field :imp, as: :impact, type: Integer

  def self.permitted_fields
    super + [:probability, :impact]
  end

  def calculate_magnitude
    self.magnitude = self.probability * self.impact

    super
  end

end
