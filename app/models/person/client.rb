class Person::Client
  include Mongoid::Document

  field :type_of, type: String
end
