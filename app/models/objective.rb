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

  field :name, type: String
  field :phrase, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person:: User

  field :lr_at, as: :last_revised_at, type: DateTime

  def log_created(user_id, body)
    log_book.new_entry(user_id, 'Creado', body)
  end

  def new_revision(user_id, fields, log_body)
    revision = revisions.create!(fields)

    if last_revised_at.nil? || revision.revised_at > last_revised_at
      self.last_revised_at = revision.revised_at
      save!
    end

    revision.log_created(user_id, log_body)
  end

  def find_revision(id)
    revisions.find(id)
  end

  def last_revision_at(format)
    last_revised_at.strftime(format) if last_revised_at
  end

  def self.display_name
    'Objetivos'
  end

  def display_name
    name
  end
end
