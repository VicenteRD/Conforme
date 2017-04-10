class Person::Client < Person
  include Mongoid::Document

  has_and_belongs_to_many :types, class_name: 'ClientType'

  def self.display_name
    'Clientes'
  end
end
