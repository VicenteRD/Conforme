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

  def create
    swot = Swot.create!(swot_fields)
    swot.log_created(current_user_id, log_body)

    create_references(swot, references_unsafe_hash)

    respond_to do |format|
      format.html { redirect_to(swot_path(swot)) }
      format.json { render json: basic_swot_json(swot) }
    end
  end

  def edit
    @swot = Swot.find(params[:id])
    redirect_to_dashboard && return unless @swot

    render layout: 'form'
  end

  def update
    swot = Swot.find(params[:id])
    redirect_to '/' && return unless swot

    swot.update!(swot_fields)
    swot.log_book.new_entry(current_user_id, 'Editado', log_body)

    # create_references(swot, references_unsafe_hash)

    redirect_to(swot_path(swot))
  end

  private

  def swot_fields
    fields = params.require(:swot)

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments

    fields.permit(
      :swot_type, :name,
      :strategy, :due_at,
      :responsible_id,
      :comments, attachment_ids: []
    )
  end

  def basic_swot_json(swot)
    { object_id: swot.id.to_s, object_name: swot.name }
  end
end
