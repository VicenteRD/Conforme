class RiskMeasurement::LawMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::LawRisk'

  field :comp, as: :compliance, type: Float #%
  field :meth, as: :method, type: String

  def calculate_magnitude
    self.magnitude = self.compliance
  end
end
