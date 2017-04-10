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

  def self.get_all_types
    ['Cadena de Valor', 'Gestión', 'Apoyo', 'Estrategia']
  end

  def new_revision(user_id, fields, log_body)
    revision = revisions.create!(fields)

    revision.log_created(user_id, log_body)
  end

  def find_revision(id)
    revisions.find(id)
  end

  def self.display_name
    'Procesos'
  end

  def display_name
    name
  end
end
