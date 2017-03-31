class CommunicationRevisionsController < ApplicationController
  def new
    @communication = Communication.find(params[:communication_id])
    redirect_to_dashboard && return unless @communication

    render 'communications/revisions/new', layout: 'form'
  end

  def edit
    @communication = Communication.find(params[:communication_id])
    redirect_to_dashboard && return unless @communication
    @revision = @communication.find_revision(params[:id])
    redirect_to_dashboard && return unless @revision

    render 'communications/revisions/edit', layout: 'form'
  end

  def create
    communication = Communication.find(params[:communication_id])
    redirect_to_dashboard && return unless communication

    revision = communication.new_revision(
      current_user_id,
      communication_revision_fields,
      log_body
    )

    create_references(revision, references_unsafe_hash, communication.id)

    redirect_to communication_path(communication)
  end

  def update
    communication = Communication.find(params[:communication_id])
    redirect_to_dashboard && return unless communication
    revision = communication.find_revision(params[:id])
    redirect_to_dashboard && return unless revision

    revision.update_and_log(
      current_user_id,
      communication_revision_fields,
      log_body
    )

    # create_references(objective, references_unsafe_hash, swot.id)

    redirect_to communication_path(communication)
  end

  private

  def communication_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments


    fields.permit(:revised_at, :comments, attachment_ids: [])
  end
end
