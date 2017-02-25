class Rule::Article
  include Mongoid::Document

  embedded_in :rule, class_name: 'Rule'

  field :name, type: String
  field :req, as: :requirement, type: String
end
