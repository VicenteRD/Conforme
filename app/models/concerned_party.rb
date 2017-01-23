class ConcernedParty
  include Mongoid::Document

  field :type_of, type: String
  field :name, type: String
  field :version, type: String

  field :description, type: String
  field :expectancy, type: String

  field :responsible_id, type: BSON::ObjectId # => Person::User
  field :time_limit, type: Time

  # Has a date
end
