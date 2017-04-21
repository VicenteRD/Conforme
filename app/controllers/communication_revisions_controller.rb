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

    revision = communication.new_revision(communication_revision_fields)
    log_created(revision)

    communication_id = communication.id
    create_references(revision, references_unsafe_hash, communication_id)
    add_attachments(
      revision, params.dig(:revision, :attachments), communication_id
    )

    redirect_to communication
  end

  def update
    communication = Communication.find(params[:communication_id])
    revision = communication ? communication.find_revision(params[:id]) : nil

    redirect_to_dashboard && return unless revision

    revision.update!(communication_revision_fields)
    log_edited(revision)

    create_references(revision, references_unsafe_hash, communication.id)

    redirect_to communication
  end

  private

  def communication_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    fields.permit(:revised_at, :comments)
  end
end
