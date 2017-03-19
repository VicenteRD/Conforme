class ProviderType
  include Mongoid::Document

  has_and_belongs_to_many :providers, class_name: 'Person::Provider'
  has_many :evaluations, class_name: 'ProviderEvaluation'

  field :name

  field :comp, as: :competencies, type: Array
  field :perf, as: :expected_performance, type: Array
end
