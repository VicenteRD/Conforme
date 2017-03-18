class PlanningsController < ApplicationController

  include DatesHelper

  def index
    render layout: 'table'
  end

  def show
    if (@planning = Planning.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:planning)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))

    planning = Planning.create!(fields.permit(
        :due_at,
        :name,
        :description,
        :comments,
        attachment_ids: []
    ))

    planning.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    create_references(planning, params[:references].to_unsafe_h) if params[:references]

    respond_to do |format|
      format.html { redirect_to planning_path(planning) }
      format.json { render json: { object_id: planning.id.to_s, object_name: planning.name } }
    end


  end

  def edit
    if (@planning = Planning.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (planning = Planning.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:planning)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))
    if params.dig(:raw, :executed)&.to_i != 0
      fields[:executed_at] = parse_datetime(params.dig(:raw, :executed_at))
    end
    planning.update!(fields.permit(
        :due_at,
        :executed_at,
        :name,
        :description,
        :comments,
        attachment_ids: []
    ))
    planning.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    redirect_to planning_path(planning)
  end
end
