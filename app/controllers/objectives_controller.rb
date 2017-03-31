class ObjectivesController < ApplicationController

  def index
    render layout: 'table'
  end

  def show
    @objective = Objective.find(params[:id])
    redirect_to_dashboard unless @objective

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def create
    objective = Objective.create!(objective_fields)
    objective.log_created(current_user_id, log_body)

    create_references(objective, references_unsafe_hash)

    respond_to do |format|
      format.html { redirect_to objective_path(objective) }
      format.json { render json: basic_objective_json(objective) }
    end
  end

  def edit
    @objective = Objective.find(params[:id])
    redirect_to_dashboard unless @objective

    render layout: 'form'
  end

  def update
    objective = Objective.find(params[:id])
    redirect_to_dashboard && return unless objective

    objective.update!(objective_fields)

    objective.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    # create_references(objective, references_unsafe_hash)

    redirect_to objective_path(objective)
  end

  private

  def basic_objective_json(objective)
    { object_id: objective.id.to_s, object_name: objective.name }
  end

  def objective_fields
    fields = params.require(:objective)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    fields.permit(
      :name,
      :phrase,
      :responsible_id,
      :comments,
      attachment_ids: []
    )
  end
end
