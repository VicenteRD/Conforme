class ObjectivesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@objective = Objective.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:objective)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    objective = Objective.create!(fields.permit(
        :name,
        :phrase,
        :responsible_id,
        :comments,
        attachment_ids: []
    ))

    objective.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    create_references(objective, params[:references].to_unsafe_h) if params[:references]

    respond_to do |format|
      format.html { redirect_to objective_path(objective) }
      format.json {
        render json: { object_id: objective.id.to_s,
                       object_name: objective.name }
      }
    end
  end

  def edit
    if (@objective = Objective.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (objective = Objective.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:objective)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    objective.update!(fields.permit(
        :name,
        :phrase,
        :responsible_id,
        :comments,
        attachment_ids: []
    ))

    objective.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    #create_references(objective, params[:references].to_unsafe_h) if params[:references]

    redirect_to objective_path(objective)
  end
end
