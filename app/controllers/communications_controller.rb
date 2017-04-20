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

  def edit
    @communication = Communication.find(params[:id])
    redirect_to_dashboard unless @communication

    render layout: 'form'
  end

  def create
    communication = Communication.create!(communication_fields)
    log_created(communication)

    create_references(communication, references_unsafe_hash)
    add_attachments(communication, params.dig(:communication, :attachments))

    respond_to do |format|
      format.html { redirect_to(communication) }
      format.json { communication_as_json(communication) }
    end
  end



  def update
    communication = Communication.find(params[:id])
    redirect_to_dashboard && return unless communication

    communication.update!(communication_fields)
    log_edited(communication)

    create_references(communication, references_unsafe_hash)

    redirect_to communication
  end

  def edit_attachments
    communication = Communication.find(params.dig(:attachments, :element_id))
    return unless communication

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(communication, additions) if additions
    remove_attachments(communication.class.name, communication, removal_ids) if
        removal_ids

    redirect_to communication
  end

  private

  def communication_as_json(communication)
    render json: {
      object_id: communication.id.to_s,
      object_name: communication.name
    }
  end

  def communication_fields
    fields = params.require(:communication)

    fields.permit(
      :communication_type,
      :name,
      :medium,
      :description,
      :responsible_id,
      :comments
    )
  end
end
