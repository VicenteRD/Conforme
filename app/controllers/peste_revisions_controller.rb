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

    revision = peste.new_revision(peste_revision_fields)
    log_created(revision)

    peste_id = peste.id
    create_references(revision, references_unsafe_hash, peste_id)
    add_attachments(
      revision, params.dig(:revision, :attachments), peste_id
    )

    redirect_to peste
  end

  def update
    peste = Peste.find(params[:peste_id])
    revision = peste ? peste.find_revision(params[:id]) : nil

    redirect_to_dashboard && return unless revision

    revision.update!(peste_revision_fields)
    log_edited(revision)

    create_references(revision, references_unsafe_hash, peste.id)

    redirect_to peste
  end

  private

  def peste_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    fields.permit(:revised_at, :comments)
  end
end
