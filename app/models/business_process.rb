class BusinessProcess
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :revisions, class_name: 'BusinessProcessRevision'

  field :name, type: String

  field :p_type, as: :process_type, type: String

  field :desc, as: :description, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId
  field :lr_at, as: :last_revised_at, type: DateTime

  def self.get_all_types
    ['Cadena de Valor', 'Gestión', 'Apoyo', 'Estrategia']
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
    'Procesos'
  end

  def display_name
    name
  end
end
