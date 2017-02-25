class Risk::RuleRisk < Risk
  include Mongoid::Document

  validates_presence_of :rule_type, :rule_id, :article_id

  embeds_many :measurements, class_name: 'RiskMeasurement::RuleMeasurement'

  field :rule_type, type: Integer

  index({rule_type: 1}, {name: 'type_index'})

  scope :law,    -> { where(rule_type: 1) }
  scope :standard, -> { where(rule_type: 2) }

  field :rule_id, type: BSON::ObjectId
  field :art_id, as: :article_id, type: BSON::ObjectId

  def self.permitted_fields
    super + [:rule_type, :rule_id, :article_id]
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

  def get_full_name
    rule = Rule.find(self.rule_id)

    rule.full_name + ', art. ' + rule.articles.find(self.article_id).name
  end

  def get_compliance
    if self.measurements&.last
      self.measurements.last.compliance
    else
      nil
    end
  end
end
