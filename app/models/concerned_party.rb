class ConcernedParty
  include Mongoid::Document

  include EnumerableDocument
  include Referable
  include Describable

  # validates_presence_of

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :p_type, as: :party_type, type: Integer
  field :name, type: String

  field :desc, as: :description, type: String
  field :exp, as: :expectation, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User
  field :due_at, type: DateTime

  def self.get_all_types
    {0 => 'Interna', 1 => 'Externa'}
  end

  def presentable_type
    ConcernedParty.get_all_types[self.party_type]
  end

  def log_created(user_id, body)
    log_book.new_entry(user_id, 'Creado', body)
  end
end
