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

    revision = objective.new_revision(
      current_user_id,
      objective_revision_fields,
      log_body
    )

    create_references(revision, references_unsafe_hash, objective.id)

    redirect_to objective_path(objective)
  end

  def update
    objective = Objective.find(params[:objective_id])
    redirect_to_dashboard && return unless objective
    revision = objective.find_revision(params[:id])
    redirect_to_dashboard && return unless revision

    revision.update_and_log(
      current_user_id,
      objective_revision_fields,
      log_body
    )

    # create_references(objective, references_unsafe_hash, swot.id)

    redirect_to objective_path(objective)
  end

  private

  def objective_revision_fields
    fields = params.require(:revision)

    fields[:revised_at] = parse_date(params.dig(:raw, :revised_at))

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments


    fields.permit(:revised_at, :comments, attachment_ids: [])
  end
end
