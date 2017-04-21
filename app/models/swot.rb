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

  field :lr_at, as: :last_revised_at, type: DateTime
  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  def self.get_all_types
    { 0 => 'Fortaleza', 1 => 'Oportunidad', 2 => 'Debilidad', 3 => 'Amenaza' }
  end

  def presentable_type
    Swot.get_all_types[swot_type]
  end

  def log_created(user_id, body)
    log_book.new_entry(user_id, 'Creado', body)
  end

  def new_revision(fields)
    revision = revisions.create!(fields)

    if last_revised_at.nil? || revision.revised_at > last_revised_at
      self.last_revised_at = revision.revised_at
      save!
    end

    revision
  end

  def find_revision(id)
    revisions.find(id)
  end

  def last_revision_at(format)
    last_revised_at.strftime(format) if last_revised_at
  end

  def display_name
    name
  end

  def self.display_name
    'FODA'
  end
end
