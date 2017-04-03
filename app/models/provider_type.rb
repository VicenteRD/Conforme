class ProviderType
  include Mongoid::Document
  include EnumerableDocument

  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  has_and_belongs_to_many :providers, class_name: 'Person::Provider'

  has_and_belongs_to_many :competencies #, autosave: true
  has_and_belongs_to_many :performances #, autosave: true

  accepts_nested_attributes_for :competencies, :performances

  has_many :evaluations, class_name: 'ProviderEvaluation'

  field :name, type: String
  field :desc, as: :description, type: String
end
