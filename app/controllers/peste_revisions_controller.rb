class PesteRevisionsController < ApplicationController
  def new
    @peste = Peste.find(params[:peste_id])
    redirect_to_dashboard && return unless @peste

    render 'peste/revisions/new', layout: 'form'
  end

  def edit
    @peste = Peste.find(params[:peste_id])
    redirect_to_dashboard && return unless @peste
    @revision = @peste.find_revision(params[:id])
    redirect_to_dashboard && return unless @revision

    render 'peste/revisions/edit', layout: 'form'
  end

  def create
    peste = Peste.find(params[:peste_id])
    redirect_to_dashboard && return unless peste

    revision = peste.new_revision(
        current_user_id,
        peste_revision_fields,
        log_body
    )

    create_references(revision, references_unsafe_hash, peste.id)

    redirect_to peste_path(peste)
  end

  def update
    peste = Peste.find(params[:peste_id])
    redirect_to_dashboard && return unless peste
    revision = peste.find_revision(params[:id])
    redirect_to_dashboard && return unless revision

    revision.update_and_log(
        current_user_id,
        peste_revision_fields,
        log_body
    )

    # create_references(objective, references_unsafe_hash, swot.id)

    redirect_to peste_path(peste)
  end

  private

  def peste_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments


    fields.permit(:revised_at, :comments, attachment_ids: [])
  end
end
