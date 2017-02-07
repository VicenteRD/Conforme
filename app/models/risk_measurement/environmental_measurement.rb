class RiskMeasurement::EnvironmentalMeasurement < RiskMeasurement

  embedded_in :risk, class_name: 'Risk::EnvironmentalRisk'

  validates_presence_of :probability,

  field :pbb, as: :probability, type: Float

  field :imp, as: :impact, type: Integer #

  field :geo_a, as: :geographical_amplitude, type: Integer #
  field :pub_p, as: :public_perception, type: Integer #
  field :rev, as: :reversibility, type: Integer #

  field :reg_br, as: :regulation_breach, type: Float # Calculated as 1 - Risk::LawRisk.find(this.base.reg_id).compliance_percentage

  def calculate_magnitude
    self.index = self.imp +
                 self.geographical_amplitude +
                 self.public_perception +
                 self.reversibility +
                 self.regulatory_breach

    self.magnitude = self.index * self.probability
  end
end
