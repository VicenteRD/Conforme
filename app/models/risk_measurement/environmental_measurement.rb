class RiskMeasurement::EnvironmentalMeasurement < RiskMeasurement

  embedded_in :risk, class_name: 'Risk::EnvironmentalRisk'

  validates_presence_of :probability,
                        :geographical_amplitude,
                        :public_perception,
                        :reversibility,
                        :criticity

  field :reg_id, as: :regulation_id, type: BSON::ObjectId # => LawRisk

  field :pbb, as: :probability, type: Float

  field :geo_a, as: :geographical_amplitude, type: Integer
  field :pub_p, as: :public_perception, type: Integer
  field :rev, as: :reversibility, type: Integer

  field :crt, as: :criticity, type: Integer

  field :reg_br, as: :regulation_breach, type: Float

  field :cons, as: :consequence, type: Float

  def self.permitted_fields
    super + [
      :probability,
      :geographical_amplitude,
      :public_perception,
      :reversibility,
      :regulation_id,
      :criticity
    ]
  end

  def calculate_magnitude
    set_regulation_breach

    self.consequence = criticity +
        geographical_amplitude +
        public_perception +
        reversibility +
        [regulation_breach, 0].max

    self.magnitude = consequence * probability

    super
  end

  def set_regulation_breach
    self.regulation_breach = -1 && return if regulation_id.nil?

    regulation = Risk::RuleRisk.find(self.regulation_id)

    compliance = regulation.get_compliance

    self.regulation_breach = compliance ? (1 - compliance) : -1
  end

  def self.display_name
    'Mediciones Riesgos Ambientales'
  end

  def display_name
    "Medición para \"#{risk.display_name}\""
  end

  def self.base_info
    { klass: Risk::EnvironmentalRisk, embeds_list: 'measurements' }
  end
end
