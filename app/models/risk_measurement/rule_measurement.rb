class RiskMeasurement::RuleMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::RuleRisk'

  validates_presence_of :compliance

  field :comp, as: :compliance, type: Float

  def self.permitted_fields
    super + [:compliance]
  end

  def calculate_magnitude
    self.magnitude = 1 - compliance

    super
  end

  def show_compliance
    (self.compliance * 100).round.to_s
  end

  def self.display_name
    "Mediciones Riesgos Normativos o Legales"
  end

  def display_name
    "Medición para \"#{risk.display_name}\""
  end

  def self.base_info
    { klass: Risk::RuleRisk, embeds_list: 'measurements' }
  end
end
