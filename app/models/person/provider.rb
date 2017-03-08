class Person::Provider
  include Mongoid::Document

  field :provider_type, type: String

  field :competencies, type: String
  field :performance, type: String
end
