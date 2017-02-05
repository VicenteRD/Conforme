class RiskMeasurement::OperationalMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::OperationalRisk'

  def calculate_magnitude
    if self.probability && self.impact
      self.magnitude = self.probability * self.impact
    else
      self.magnitude = 0
    end
  end

end
