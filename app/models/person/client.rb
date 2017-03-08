class Person::Client
  include Mongoid::Document

  field :client_type, type: String
end
