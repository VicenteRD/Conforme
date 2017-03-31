class BusinessProcessRevisionsController < ApplicationController
  def new
    @business_process = BusinessProcess.find(params[:process_id])
    redirect_to_dashboard && return unless @business_process

    render 'business_processes/revisions/new', layout: 'form'
  end

  def edit
    @business_process = BusinessProcess.find(params[:process_id])
    redirect_to_dashboard && return unless @business_process
    @revision = @business_process.find_revision(params[:id])
    redirect_to_dashboard && return unless @revision

    render 'business_processes/revisions/edit', layout: 'form'
  end

  def create
    business_process = BusinessProcess.find(params[:process_id])
    redirect_to_dashboard && return unless business_process

    revision = business_process.new_revision(
      current_user_id,
      revision_fields,
      log_body
    )

    create_references(revision, references_unsafe_hash, business_process.id)

    redirect_to business_process_path(business_process)
  end

  def update
    business_process = BusinessProcess.find(params[:process_id])
    redirect_to_dashboard && return unless business_process
    revision = business_process.find_revision(params[:id])
    redirect_to_dashboard && return unless revision

    revision.update_and_log(
      current_user_id,
      revision_fields,
      log_body
    )

    # create_references(objective, references_unsafe_hash, swot.id)

    redirect_to business_process_path(business_process)
  end

  private

  def revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments


    fields.permit(:revised_at, :comments, attachment_ids: [])
  end
end
