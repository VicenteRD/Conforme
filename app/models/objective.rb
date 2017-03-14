class Objective
  include Mongoid::Document

  field :c_id, as: :creator_id, type: BSON::ObjectId # => Person:: User
  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person:: User

  has_many :indicators

  field :name, type: String
  field :phrase, type: String
end
