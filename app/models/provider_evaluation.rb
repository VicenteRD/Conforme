class ProviderEvaluation
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument

  belongs_to :eval_group, class_name: 'ProviderType'
  belongs_to :eval_person, class_name: 'Person::Provider'
  alias evaluated_provider eval_person
  alias evaluated_type eval_group

  belongs_to :evaluator, class_name: 'Person::User'

  embeds_many :qualification_evaluations
  accepts_nested_attributes_for :qualification_evaluations

  field :q_type, as: :qualification_type, type: Integer

  index({ qualification_type: 1 }, name: 'qualification_type_index')

  scope :competency,  -> { where(qualification_type: 0) }
  scope :performance, -> { where(qualification_type: 1) }

  field :eval_at, as: :evaluated_at, type: DateTime

  def self.person_types
    { 0 => 'employee', 1 => 'provider' }
  end

  def self.qualifications_types
    Qualification.all_types
  end

  def presentable_qualification_type(lang = :en)
    type_name = Qualification.all_types[qualification_type]

    type_name = 'desempeño' if type_name == 'performance' && lang == :es

    type_name
  end
end
