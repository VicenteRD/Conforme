class Objective
  include Mongoid::Document

  include EnumerableDocument
  include Referable
  include Describable

  # validates_presence_of

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  has_many :indicators

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person:: User

  field :name, type: String
  field :phrase, type: String
end
