class RiskMeasurement::StandardMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::StandardRisk'

  field :comp, as: :compliance, type: Float #%
  field :meth, as: :method, type: String

  def calculate_magnitude
    self.magnitude = self.compliance
  end
end
