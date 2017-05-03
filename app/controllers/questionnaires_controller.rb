class QuestionnairesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
    redirect_to_dashboard unless @questionnaire

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @questionnaire = Questionnaire.find(params[:id])
    redirect_to_dashboard unless @questionnaire

    render layout: 'form'
  end

  def create
    questionnaire = Questionnaire.create!(questionnaire_fields)
    log_created(questionnaire)

    generate_questions(questionnaire)

    create_references(questionnaire, references_unsafe_hash)
    process_attachments(questionnaire)

    redirect_to questionnaire
  end

  def update
    questionnaire = Questionnaire.find(params[:id])
    redirect_to_dashboard && return unless questionnaire

    questionnaire.update!(definition_fields)
    log_edited(questionnaire)

    create_references(questionnaire, references_unsafe_hash)
    process_attachments(questionnaire)

    redirect_to questionnaire
  end

  private

  def questionnaire_fields
    fields = params.require(:questionnaire)

    fields[:due_at] = parse_date(params.dig(:raw, :due_at))

    fields.permit(
      :name,
      :due_at,
      :questionnaire_type,
      :comments
    )
  end

  def generate_questions(questionnaire)
    0.step do |idx|
      q_idx = "question_#{idx}".to_sym
      q_params = params.key?(q_idx) ? params.require(q_idx) : nil
      break unless q_params

      question = questionnaire.create_question(
        q_params.permit(:name, :question_type, :required)
      )

      alternatives = generate_alternatives(q_params)
      question.generate_alternatives(alternatives)
    end
  end

  def generate_alternatives(question_parameters)
    right_answer = question_parameters[:right_answer]
    correct_idx = right_answer ? right_answer.to_i : -1

    alternatives = {}
    (0..4).step do |idx|
      alternative = question_parameters["answer_#{idx}".to_sym]
      next if alternative.nil? || alternative.empty?

      alternatives[alternative] = idx == correct_idx
    end

    alternatives
  end

  def process_attachments(questionnaire)
    additions = params.dig(:questionnaire, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(questionnaire, additions) if additions
    remove_attachments('Questionnaire', questionnaire, removals) if removals
  end
end
