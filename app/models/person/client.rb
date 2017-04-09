class Person::Client < Person
  include Mongoid::Document

  has_and_belongs_to_many :types, class_name: 'ClientType'
end
