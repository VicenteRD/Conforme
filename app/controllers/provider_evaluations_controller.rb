class ProviderEvaluationsController < ApplicationController

  def index
    @type = parse_evaluation_type(params[:type])
    redirect_to_dashboard && return unless @type

    render layout: 'table'
  end

  def show
    @evaluation = PersonEvaluation.find(params[:id])
    redirect_to_dashboard && return unless @evaluation

    render layout: 'show'
  end

  def new
    @type = parse_evaluation_type(params[:type])
    redirect_to_dashboard && return unless @type

    render layout: 'form'
  end

  def create
    type = parse_evaluation_type(params[:type])
    redirect_to_dashboard && return unless type

    evaluation = ProviderEvaluation.create!(evaluation_fields(type))

    load_evaluated_qualifications(evaluation)

    # evaluation.log_book.new_entry(current_user_id, 'Creado', log_body)
  end

  def load_qualifications
    @loader = PersonEvaluationLoader.new(Person::Provider, ProviderType, params)

    render 'evaluations/load_qualifications', layout: false
  end

  private

  def evaluation_fields(type)
    fields = params.require(:person_evaluation)

    fields[:qualification_type] = parse_evaluation_type(type)
    fields[:evaluated_at] = parse_date(params.dig(:raw, :evaluated_at))

    fields.permit(:evaluated_at, :eval_person_id, :evaluator_id, :eval_group_id)
  end

  def load_evaluated_qualifications(evaluation)
    0.step do |idx|
      sub_param = params.dig(:person_evaluation, "evaluation_for_#{idx}".to_sym)
      break unless sub_param

      create_evaluation(evaluation, sub_param)
    end
  end

  def create_evaluation(provider_evaluation, params)
    provider_evaluation.qualification_evaluations.create!(
      params.permit(
        :qualification_id, :grade, :comments
      )
    )
    provider_evaluation.save!
  end

  def parse_evaluation_type(type)
    if type == 'competencias'
      1
    elsif type == 'performance'
      2
    end
  end
end
