class BusinessProcess
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :name, type: String

  field :p_type, as: :process_type, type: String

  field :desc, as: :description, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId

  def self.get_all_types
    ['Cadena de Valor', 'Gestión', 'Apoyo', 'Estrategia']
  end
end
