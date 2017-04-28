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

  def edit
    @objective = Objective.find(params[:id])
    redirect_to_dashboard unless @objective

    render layout: 'form'
  end

  def create
    objective = Objective.create!(objective_fields)
    log_created(objective)

    create_references(objective, references_unsafe_hash)
    add_attachments(objective, params.dig(:objective, :attachments))

    respond_to do |format|
      format.html { redirect_to(objective) }
      format.json { objective_as_json(objective) }
    end
  end

  def update
    objective = Objective.find(params[:id])
    redirect_to_dashboard && return unless objective

    objective.update!(objective_fields)
    log_edited(objective)

    create_references(objective, references_unsafe_hash)

    redirect_to objective
  end

  def edit_attachments
    objective = Objective.find(params.dig(:attachments, :element_id))
    return unless objective

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(objective, additions) if additions
    remove_attachments(objective.class.name, objective, removal_ids) if
        removal_ids

    redirect_to objective
  end

  private

  def objective_as_json(objective)
    render json: {
      object_id: objective.id.to_s,
      object_name: objective.name
    }
  end

  def objective_fields
    fields = params.require(:objective)

    fields.permit(
      :name,
      :phrase,
      :responsible_id,
      :comments
    )
  end
end
