class Objective
  include Mongoid::Document

  field :creator_id, type: BSON::ObjectId # => Person:: User
  field :responsible_id, type: BSON::ObjectId # => Person:: User

  has_many :indicators

  field :name, type: String
  field :phrase, type: String
end
