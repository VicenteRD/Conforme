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
    process = BusinessProcess.find(params[:process_id])
    redirect_to_dashboard && return unless process

    revision = process.new_revision(revision_fields)
    log_created(revision)

    process_id = process.id
    create_references(revision, references_unsafe_hash, process_id)
    add_attachments(
      revision, params.dig(:revision, :attachments), process_id
    )

    redirect_to process
  end

  def update
    process = BusinessProcess.find(params[:process_id])
    revision = process ? process.find_revision(params[:id]) : nil

    redirect_to_dashboard && return unless revision

    revision.update!(revision_fields)
    log_edited(revision)

    create_references(revision, references_unsafe_hash, process.id)

    redirect_to process
  end

  private

  def revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    fields.permit(:revised_at, :comments)
  end
end
