class Objective
  include Mongoid::Document

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :c_id, as: :creator_id, type: BSON::ObjectId # => Person:: User
  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person:: User

  has_many :indicators

  field :name, type: String
  field :phrase, type: String
end
