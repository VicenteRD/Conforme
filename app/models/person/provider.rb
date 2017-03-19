class Person::Provider < Person
  include Mongoid::Document

  include Referable

  has_and_belongs_to_many :types, class_name: 'ProviderType'
  has_many :evaluations, class_name: 'ProviderEvaluation'
end
