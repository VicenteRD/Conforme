class Person::Provider
  include Mongoid::Document

  field :type_of, type: String

  field :competencies, type: String
  field :performance, type: String
end
