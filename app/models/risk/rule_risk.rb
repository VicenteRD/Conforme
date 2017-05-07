class Risk::RuleRisk < Risk
  include Mongoid::Document

  validates_presence_of :rule_type, :rule_id, :numeral, :title

  embeds_many :measurements, class_name: 'RiskMeasurement::RuleMeasurement'

  field :rule_type, type: Integer

  index({ rule_type: 1 }, name: 'type_index')

  scope :law,      -> { where(rule_type: 1) }
  scope :standard, -> { where(rule_type: 2) }

  field :rule_id, type: BSON::ObjectId

  field :compliance, type: Float
  field :real_compliance, type: Float, default: 0

  field :numeral, type: String
  field :title, type: String
  field :requirement, type: String

  def self.permitted_fields
    super + [:rule_type, :rule_id, :numeral, :title, :requirement]
  end

  def new_measurement(values)
    measurement = measurements.create!(values)

    calculate_compliance

    measurement
  end


  def full_rule_name
    rule = Rule.find(rule_id)
    if rule
      rule.rule_type == 1 ? rule.name : rule.full_name
    end
  end

  def get_compliance # TODO find and replace
    compliance
  end

  def calculate_compliance
    if (measurement = measurements.order(measured_at: :desc, created_at: :desc).first)
      self.compliance = measurement.compliance
      self.real_compliance = self.compliance
    else
      self.compliance = 0
      self.real_compliance = 0
    end

    save!
  end

  def display_name
    "#{full_rule_name} - #{numeral}"
  end

  def self.display_name
    'Riesgos Normativos y Legales'
  end
end
