class PesteRevision
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include Describable

  embedded_in :peste

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :rev_at, as: :revised_at, type: DateTime

  def self.display_name
    'Revisiones de Análisis PESTA'
  end

  def display_name
    "Revisión para \"#{peste.display_name}\""
  end

  def self.base_info
    { klass: Peste, embeds_list: 'revisions' }
  end
end
