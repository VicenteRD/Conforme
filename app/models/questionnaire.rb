class Questionnaire
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :questions, class_name: 'QuestionnaireQuestion'

  # Don't know if this is best, but I've got to start somewhere
  embeds_many :responses, class_name: 'QuestionnaireResponse'

  field :q_type, as: :questionnaire_type, type: Integer

  index({ questionnaire_type: 1 }, name: 'type_index')

  scope :external, -> { where(questionnaire_type: 1) }
  scope :internal, -> { where(questionnaire_type: 2) }

  field :doc_id, as: :document_id, type: BSON::ObjectId

  field :name, type: String

  field :due_at, type: DateTime


  def self.all_types
    { 1 => 'Externo', 2 => 'Interno' }
  end

  def presentable_type
    Questionnaire.all_types[questionnaire_type]
  end

  def create_question(fields)
    questions.create!(fields)
  end

  def delete_questions
    questions.destroy_all
    reload
  end

  def document_name
    return unless document_id

    # document = Document.find(document_id)
    # document.name
  end
end
