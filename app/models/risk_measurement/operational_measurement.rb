class RiskMeasurement::OperationalMeasurement < RiskMeasurement
  include Mongoid::Document

  embedded_in :risk, class_name: 'Risk::OperationalRisk'

  validates_presence_of :probability, :impact

  field :pbb, as: :probability, type: Float

  field :imp, as: :impact, type: Integer

  field :i_pbb, as: :initial_probability, type: Float
  field :i_imp, as: :initial_impact, type: Integer

  def self.permitted_fields
    super + [:probability, :impact, :initial_probability, :initial_impact]
  end

  def calculate_magnitude
    self.initial_magnitude = initial_probability * initial_impact
    self.magnitude = probability * impact

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
