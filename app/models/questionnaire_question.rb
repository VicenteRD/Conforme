class QuestionnaireQuestion
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embedded_in :questionnaire, class_name: 'Questionnaire'

  field :name, type: String

  field :q_type, as: :question_type, type: Integer
  field :req, as: :required, type: Boolean

  field :alternatives, type: Hash

  def self.all_types
    { 1 => 'Alternativas', 2 => 'Abierta' }
  end

  def generate_alternatives(alternatives)
    # Do not set alternatives to an empty hash.
    # An empty hash would mean an open question, which can then
    # be identified with the `alternatives?` method.
    return if alternatives.empty?

    self.alternatives = alternatives

    save!
  end
end
