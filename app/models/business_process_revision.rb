class BusinessProcessRevision
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include Describable

  embedded_in :business_process

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :rev_at, as: :revised_at, type: DateTime

  def self.display_name
    'Revisiones de Procesos'
  end

  def display_name
    "Revisión para \"#{business_process.display_name}\""
  end

  def self.base_info
    { klass: BusinessProcess, embeds_list: 'revisions' }
  end
end
