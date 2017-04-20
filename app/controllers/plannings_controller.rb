class PlanningsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @planning = Planning.find(params[:id])
    redirect_to_dashboard unless @planning

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @planning = Planning.find(params[:id])
    redirect_to_dashboard unless @planning

    render layout: 'form'
  end

  def create
    planning = Planning.create!(planning_fields)
    log_created(planning)

    create_references(planning, references_unsafe_hash)
    add_attachments(planning, params.dig(:planning, :attachments))

    respond_to do |format|
      format.html { redirect_to(planning) }
      format.json { planning_as_json(planning) }
    end
  end

  def update
    planning = Planning.find(params[:id])
    redirect_to_dashboard && return unless planning

    planning.update!(planning_fields)
    log_edited(planning)

    create_references(planning, references_unsafe_hash)

    redirect_to planning
  end

  def edit_attachments
    planning = Planning.find(params.dig(:attachments, :element_id))
    return unless planning

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(planning, additions) if additions
    remove_attachments(planning.class.name, planning, removal_ids) if
        removal_ids

    redirect_to planning
  end

  private

  def planning_fields
    fields = params.require(:planning)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))

    exec = params.dig(:raw, :executed)
    fields[:executed_at] = parse_datetime(params.dig(:raw, :executed_at)) if
        exec && exec.to_i != 0

    fields.permit(
      :due_at,
      :executed_at,
      :name,
      :description,
      :comments
    )
  end

  def planning_as_json(planning)
    render json: {
      object_id: planning.id.to_s,
      object_name: planning.name
    }
  end
end
