class Audit
  include Mongoid::Document

  include Describable
  include EnumerableDocument
  include Referable

  embedded_in :program, class_name: 'AuditProgram'

  embeds_many :items, class_name: 'AuditItem'

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :name, type: String
  field :audited_at, type: DateTime

  def create_item(fields)
    items.create!(fields)
  end
end
