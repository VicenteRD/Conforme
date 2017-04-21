class ObjectiveRevisionsController < ApplicationController
  def new
    @objective = Objective.find(params[:objective_id])
    redirect_to_dashboard && return unless @objective

    render 'objectives/revisions/new', layout: 'form'
  end

  def edit
    @objective = Objective.find(params[:objective_id])
    redirect_to_dashboard && return unless @objective
    @revision = @objective.find_revision(params[:id])
    redirect_to_dashboard && return unless @revision

    render 'objectives/revisions/edit', layout: 'form'
  end

  def create
    objective = Objective.find(params[:objective_id])
    redirect_to_dashboard && return unless objective

    revision = objective.new_revision(objective_revision_fields)
    log_created(revision)

    objective_id = objective.id
    create_references(revision, references_unsafe_hash, objective_id)
    add_attachments(
      revision, params.dig(:revision, :attachments), objective_id
    )

    redirect_to objective
  end

  def update
    objective = Objective.find(params[:objective_id])
    revision = objective ? objective.find_revision(params[:id]) : nil

    redirect_to_dashboard && return unless revision

    revision.update!(objective_revision_fields)
    log_edited(revision)

    create_references(revision, references_unsafe_hash, objective.id)

    redirect_to objective
  end

  private

  def objective_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    fields.permit(:revised_at, :comments)
  end
end
