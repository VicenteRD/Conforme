class RiskMeasurement::EnvironmentalMeasurement < RiskMeasurement

  embedded_in :risk, class_name: 'Risk::EnvironmentalRisk'

  validates_presence_of :probability

  field :pbb, as: :probability, type: Float

  field :geo_a, as: :geographical_amplitude, type: Integer #
  field :pub_p, as: :public_perception, type: Integer #
  field :rev, as: :reversibility, type: Integer #

  field :imp, as: :impact, type: Integer #

  field :reg_br, as: :regulation_breach, type: Float # Calculated as 1 - Risk::LawRisk.find(this.base.reg_id).compliance_percentage

  field :cons, as: :consequence, type: Float

  def calculate_magnitude
    self.consequence = self.imp +
        self.geographical_amplitude +
        self.public_perception +
        self.reversibility +
        self.regulatory_breach

    self.magnitude = self.consequence * self.probability

    super
  end
end
