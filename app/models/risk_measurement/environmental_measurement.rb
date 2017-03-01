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
    self.set_regulation_breach

    self.consequence = self.criticity +
        self.geographical_amplitude +
        self.public_perception +
        self.reversibility +
        [self.regulation_breach, 0].max

    self.magnitude = self.consequence * self.probability

    super
  end

  def set_regulation_breach
    if self.regulation_id.nil?
      self.regulation_breach = -1 and return
    end

    regulation = Risk::RuleRisk.find(self.regulation_id)


    self.regulation_breach = regulation&.get_compliance ? (1 - regulation.get_compliance) : -1
  end
end
