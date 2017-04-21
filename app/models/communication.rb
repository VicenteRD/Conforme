class Communication
  include Mongoid::Document

  include EnumerableDocument
  include Referable
  include Describable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :revisions, class_name: 'CommunicationRevision'

  field :comm_type, as: :communication_type, type: Integer

  field :name, type: String
  field :med, as: :medium, type: String
  field :desc, as: :description, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId
  field :lr_at, as: :last_revised_at, type: DateTime

  def self.all_types
    { 0 => 'Interna', 1 => 'Externa' }
  end

  def presentable_type
    Communication.all_types[communication_type]
  end

  def new_revision(fields)
    revision = revisions.create!(fields)

    if last_revised_at.nil? || revision.revised_at > last_revised_at
      self.last_revised_at = revision.revised_at
      save!
    end
  end

  def find_revision(id)
    revisions.find(id)
  end

  def last_revision_at(format)
    last_revised_at.strftime(format) if last_revised_at
  end

  def self.display_name
    'Comunicaciones'
  end

  def display_name
    name
  end
end
