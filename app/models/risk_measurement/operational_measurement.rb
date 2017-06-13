class RiskMeasurement::OperationalMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::OperationalRisk'

  validates_presence_of :probability, :impact

  field :pbb, as: :probability, type: Float

  field :imp, as: :impact, type: Integer

  field :i_pbb, as: :initial_probability, type: Float
  field :i_imp, as: :initial_impact, type: Integer

  def self.permitted_fields
    super + [:probability, :impact]
  end

  def calculate_magnitude
    self.magnitude = self.probability * self.impact

    super
  end

  def self.display_name
    'Mediciones Riesgos Operacionales'
  end

  def display_name
    "Medición para \"#{risk.display_name}\""
  end

  def self.base_info
    { klass: Risk::OperationalRisk, embeds_list: 'measurements' }
  end
end
