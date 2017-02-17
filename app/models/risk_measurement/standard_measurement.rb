class RiskMeasurement::StandardMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::StandardRisk'

  validates_presence_of :compliance, :method

  field :comp, as: :compliance, type: Float

  field :meth, as: :method, type: String

  def self.permitted_fields
    super + [:compliance, :method]
  end

  def calculate_magnitude
    self.magnitude = 1 - self.compliance

    super
  end
end
