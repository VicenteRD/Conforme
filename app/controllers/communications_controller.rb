class CommunicationsController < ApplicationController

  def index
    render layout: 'table'
  end

  def show
    @communication = Communication.find(params[:id])
    redirect_to_dashboard unless @communication

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def create
    communication = Communication.create!(communication_fields)
    communication.log_created(current_user_id, log_body)

    create_references(communication, references_unsafe_hash)

    respond_to do |format|
      format.html { redirect_to communication_path(communication) }
      format.json { render json: basic_communication_json(communication) }
    end
  end

  def edit
    @communication = Communication.find(params[:id])
    redirect_to_dashboard unless @communication

    render layout: 'form'
  end

  def update
    communication = Communication.find(params[:id])
    redirect_to_dashboard && return unless communication

    communication.update!(communication_fields)

    communication.log_book.new_entry(current_user_id, 'Editado', log_body)

    #create_references(objective, params[:references].to_unsafe_h) if params[:references]

    redirect_to communication_path(communication)
  end

  private

  def basic_communication_json(communication)
    { object_id: communication.id.to_s, object_name: communication.name }
  end

  def communication_fields
    fields = params.require(:communication)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    fields.permit(
      :communication_type,
      :name,
      :medium,
      :description,
      :responsible_id,
      :comments,
      attachment_ids: []
    )
  end
end
