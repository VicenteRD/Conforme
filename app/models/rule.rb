class Rule
  include Mongoid::Document

  field :rule_type, type: Integer

  index({rule_type: 1}, {name: 'type_index'})

  scope :law,    -> { where(rule_type: 1) }
  scope :standard, -> { where(rule_type: 2) }

  field :ins, as: :institution, type: String
  field :name, type: String

  def full_name
    self.institution + (self.rule_type == 1 ? ': ' : ' ') + self.name
  end

  def get_rule_type_name
    case self.rule_type
      when 1
        {en: 'law', es: 'ley'}
      when 2
        {en: 'standard', es: 'norma'}
      else
        {en: 'nil', es: 'nulo'}
    end
  end
end
