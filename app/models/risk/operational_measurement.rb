class Risk::OperationalMeasurement < Risk::Measurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::Operational'

  def calculate_magnitude
    if self.probability && self.impact
      self.magnitude = self.probability * self.impact
    else
      self.magnitude = 0
    end
  end

end
