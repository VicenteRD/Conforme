class RiskMeasurement::RuleMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::RuleRisk'

  validates_presence_of :compliance

  field :comp, as: :compliance, type: Float

  def self.permitted_fields
    super + [:compliance]
  end

  def calculate_magnitude
    self.magnitude = 1 - self.compliance

    super
  end

  def show_compliance
    (self.compliance * 100).round.to_s
  end
end
