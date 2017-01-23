class Document
  include Mongoid::Document

  ## Relations
  has_many :users, through: :read_status
  belongs_to :position

  field :creator_id, type: BSON::ObjectId # => Person::User
  field :editor_id, type: BSON::ObjectId # => Person::User
  field :publisher_id, type: BSON::ObjectId # => Person::User

  # c_at, e_at and p_at are the times at which each user did their
  # job (create, edit and publish).
  include Mongoid::Timestamps::Short
  field :p_at, type: DateTime

  embeds_one :log_book, class_name: 'Log::Book', foreign_key: 'log_id'

end
