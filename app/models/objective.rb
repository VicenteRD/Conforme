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

  embeds_many :revisions, class_name: 'ObjectiveRevision'

  has_many :indicators

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person:: User

  field :name, type: String
  field :phrase, type: String

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
