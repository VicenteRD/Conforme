class ConcernedParty
  include Mongoid::Document

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book ||= Log::Book.new
  end

  field :p_type, as: :party_type, type: String
  field :name, type: String

  field :desc, as: :description, type: String
  field :exp, as: :expectation, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User
  field :due_at, type: DateTime

  field :cmts, as: :comments, type: String
end
