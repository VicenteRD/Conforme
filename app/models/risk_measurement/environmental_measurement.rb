class RiskMeasurement::EnvironmentalMeasurement < RiskMeasurement

  embedded_in :risk, class_name: 'Risk::EnvironmentalRisk'

  validates_presence_of :probability,
                        :geographical_amplitude,
                        :public_perception,
                        :reversibility,
                        :impact

  field :pbb, as: :probability, type: Float

  field :geo_a, as: :geographical_amplitude, type: Integer
  field :pub_p, as: :public_perception, type: Integer
  field :rev, as: :reversibility, type: Integer

  field :imp, as: :impact, type: Integer

  field :reg_br, as: :regulation_breach, type: Float

  field :cons, as: :consequence, type: Float

  def self.permitted_fields
    super + [
        :probability,
        :geographical_amplitude,
        :public_perception,
        :reversibility,
        :regulation_breach,
        :impact
    ]
  end

  def calculate_magnitude
    # regulation_breach is given via a hidden field in the form,
    # taken from the base risk

    self.consequence = self.imp +
        self.geographical_amplitude +
        self.public_perception +
        self.reversibility +
        [self.regulation_breach, 0].max
    self.magnitude = self.consequence * self.probability

    super
  end
end
