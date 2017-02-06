class Swot::Field
  include Mongoid::Document

  embedded_in :swot

  # % de medicion

  field :type_of, type: String
  field :name, type: String
  field :version, type: String

  field :description, type: String
  field :strategy, type: String

  field :responsible_id, type: BSON::ObjectId # => Person::User
  field :time_limit, type: DateTime

  # Has dates
end
