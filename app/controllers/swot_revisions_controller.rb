class SwotRevisionsController < ApplicationController
  def new
    @swot = Swot.find(params[:swot_id])
    redirect_to_dashboard && return unless @swot

    render 'swot/revisions/new', layout: 'form'
  end

  def edit
    @swot = Swot.find(params[:swot_id])
    redirect_to_dashboard && return unless @swot
    @revision = @swot.find_revision(params[:id])
    redirect_to_dashboard && return unless @revision

    render 'swot/revisions/edit', layout: 'form'
  end

  def create
    swot = Swot.find(params[:swot_id])
    redirect_to_dashboard && return unless swot

    revision = swot.new_revision(
      current_user_id,
      swot_revision_fields,
      log_body
    )

    create_references(revision, references_unsafe_hash, swot.id)

    redirect_to swot_path(swot)
  end

  def update
    swot = Swot.find(params[:swot_id])
    redirect_to_dashboard && return unless swot
    revision = swot.find_revision(params[:id])
    redirect_to_dashboard && return unless revision

    revision.update_and_log(
      current_user_id,
      swot_revision_fields,
      log_body
    )

    # create_references(objective, references_unsafe_hash, swot.id)

    redirect_to swot_path(swot)
  end

  private

  def swot_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments


    fields.permit(:revised_at, :comments, attachment_ids: [])
  end
end
