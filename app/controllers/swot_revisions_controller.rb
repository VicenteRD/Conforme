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

    revision = swot.new_revision(swot_revision_fields)
    log_created(revision)

    swot_id = swot.id
    create_references(revision, references_unsafe_hash, swot_id)
    add_attachments(
      revision, params.dig(:revision, :attachments)
    )

    redirect_to swot
  end

  def update
    swot = Swot.find(params[:swot_id])
    revision = swot ? swot.find_revision(params[:id]) : nil

    redirect_to_dashboard && return unless revision

    revision.update!(swot_revision_fields)
    log_edited(revision)

    create_references(revision, references_unsafe_hash, swot.id)

    redirect_to swot
  end

  private

  def swot_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    fields.permit(:revised_at, :comments)
  end
end
