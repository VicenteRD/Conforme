class RiskMeasurement::SafetyMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::SafetyRisk'

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

  def self.display_name
    'Mediciones Riesgos de Seguridad'
  end

  def display_name
    "Medición para \"#{risk.display_name}\""
  end

  def self.base_info
    { klass: Risk::SafetyRisk, embeds_list: 'measurements' }
  end
end
