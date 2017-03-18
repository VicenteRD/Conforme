class Risk::RuleRisk < Risk
  include Mongoid::Document

  validates_presence_of :rule_type, :rule_id, :numeral, :title

  embeds_many :measurements, class_name: 'RiskMeasurement::RuleMeasurement'

  field :rule_type, type: Integer

  index({rule_type: 1}, {name: 'type_index'})

  scope :law,      -> { where(rule_type: 1) }
  scope :standard, -> { where(rule_type: 2) }

  field :rule_id, type: BSON::ObjectId

  field :compliance, type: Float

  field :numeral, type: String
  field :title, type: String
  field :requirement, type: String

  def self.permitted_fields
    super + [:rule_type, :rule_id, :numeral, :title, :requirement]
  end

  def new_measurement(values)
    measurement = self.measurements.create!(values)
  end

  #def get_rule_type
  #  case type
  #    when 1
  #      {en: 'law', es: 'ley'}
  #    when 2
  #      {en: 'standard', es: 'norma'}
  #    else
  #      {en: 'nil', es: 'nulo'}
  #  end
  #end

  def full_rule_name


    if (rule = Rule.find(self.rule_id))
      rule.rule_type == 1 ? rule.name : rule.full_name
    else
      nil
    end
  end
  #def get_full_name
  #  rule = Rule.find(self.rule_id)

  #   rule.full_name + ', art. ' + rule.articles.find(self.article_id).name
  #end

  #def get_article_name
  #  Rule.find(self.rule_id).articles.find(self.article_id).name
  #end

  def get_compliance
    if self.measurements&.last
      self.measurements.last.compliance
    else
      nil
    end
  end

  def calculate_compliance
    if (measurement = measurements.order(measured_at: :desc, created_at: :desc).first)
      puts 'HELLOOOOO'
      self.compliance = measurement.compliance
    else
      self.compliance = 0
    end

    self.save!
  end
end
