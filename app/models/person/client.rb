class Person::Client < Person
  include Mongoid::Document

  field :client_type, type: String
end
