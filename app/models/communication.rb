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

  def self.all_types
    { 0 => 'Interna', 1 => 'Externa' }
  end

  def presentable_type
    Communication.all_types[communication_type]
  end

  def log_created(user_id, body)
    log_book.new_entry(user_id, 'Creado', body)
  end

  def new_revision(user_id, fields, log_body)
    revision = revisions.create!(fields)

    revision.log_created(user_id, log_body)
  end

  def find_revision(id)
    revisions.find(id)
  end
end
