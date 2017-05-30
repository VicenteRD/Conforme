class EmployeeEvaluation
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument

  belongs_to :eval_group, class_name: 'Position'
  belongs_to :eval_person, class_name: 'Person::User'
  alias evaluated_employee eval_person
  alias evaluated_position eval_group

  belongs_to :evaluator, class_name: 'Person::User'

  embeds_many :qualification_evaluations
  accepts_nested_attributes_for :qualification_evaluations

  field :q_type, as: :qualification_type, type: Integer

  index({ qualification_type: 1 }, name: 'qualification_type_index')

  scope :competency,  -> { where(qualification_type: 0) }
  scope :performance, -> { where(qualification_type: 1) }

  field :eval_at, as: :evaluated_at, type: DateTime
  field :eval_end, as: :evaluated_at_end, type: DateTime

  def presentable_qualification_type(lang = :en)
    type_name = Qualification.all_types[qualification_type]

    type_name = 'desempeño' if type_name == 'performance' && lang == :es

    type_name
  end

  def average_grade
    qualification_evaluations.avg(:grade)
  end

  def self.person_types
    { 0 => 'employee', 1 => 'provider' }
  end

  def self.qualifications_types
    Qualification.all_types
  end

  def display_name
    "#{evaluated_position.name} -> #{evaluated_employee.first_last_name} (#{presentable_qualification_type(:es).capitalize})"
  end

  def self.display_name
    'Evaluaciones Personas'
  end


end
