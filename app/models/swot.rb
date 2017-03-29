class Swot
  include Mongoid::Document

  include EnumerableDocument
  include Referable
  include Describable

  validates_presence_of :responsible_id, :swot_type

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :revisions, class_name: 'SwotRevision'

  field :swot_type, type: Integer
  field :name, type: String

  field :strategy, type: String

  field :due_at, type: DateTime
  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  def self.get_all_types
    { 0 => 'Fortaleza', 1 => 'Oportunidad', 2 => 'Debilidad', 3 => 'Amenaza' }
  end

  def presentable_type
    Swot.get_all_types[self.swot_type]
  end
end
