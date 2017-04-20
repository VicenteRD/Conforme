class SwotController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @swot = Swot.find(params[:id])
    redirect_to_dashboard && return unless @swot

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @swot = Swot.find(params[:id])
    redirect_to_dashboard && return unless @swot

    render layout: 'form'
  end

  def create
    swot = Swot.create!(swot_fields)
    log_created(swot)

    create_references(swot, references_unsafe_hash)
    add_attachments(swot, params.dig(:swot, :attachments))

    respond_to do |format|
      format.html { redirect_to(swot) }
      format.json { swot_as_json(swot) }
    end
  end

  def update
    swot = Swot.find(params[:id])
    redirect_to_dashboard && return unless swot

    swot.update!(swot_fields)
    log_edited(swot)

    create_references(swot, references_unsafe_hash)

    redirect_to swot
  end

  def edit_attachments
    swot = Swot.find(params.dig(:attachments, :element_id))
    return unless swot

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(swot, additions) if additions
    remove_attachments(swot.class.name, swot, removal_ids) if
        removal_ids

    redirect_to swot
  end

  private

  def swot_fields
    fields = params.require(:swot)

    fields.permit(
      :swot_type, :name,
      :strategy, :due_at,
      :responsible_id,
      :comments
    )
  end

  def swot_as_json(swot)
    render json: {
      object_id: swot.id.to_s,
      object_name: swot.name
    }
  end
end
