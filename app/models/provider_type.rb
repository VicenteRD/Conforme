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

  has_many :evaluations, class_name: 'ProviderEvaluation'

  field :comp_ids, as: :competency_ids, type: Array
  field :perf_ids, as: :performance_ids, type: Array

  field :name, type: String
  field :desc, as: :description, type: String

  def qualifications(qualifications_type)
    if qualifications_type == 1
      competency_ids
    elsif qualifications_type == 2
      performance_ids
    end
  end

  def self.display_name
    'Tipos de Proveedores'
  end

  def display_name
    name
  end
end
