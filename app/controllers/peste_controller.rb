class PesteController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @peste = Peste.find(params[:id])
    redirect_to_dashboard && return unless @peste

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def create
    peste = Peste.create!(peste_fields)
    peste.log_created(current_user_id, log_body)

    create_references(peste, references_unsafe_hash)

    respond_to do |format|
      format.html { redirect_to(peste_path(peste)) }
      format.json { render json: basic_peste_json(peste) }
    end
  end

  def edit
    @peste = Peste.find(params[:id])
    redirect_to_dashboard && return unless @peste

    render layout: 'form'
  end

  def update
    peste = Peste.find(params[:id])
    redirect_to_dashboard && return unless peste

    peste.update!(peste_fields)
    peste.log_book.new_entry(current_user_id, 'Editado', log_body)

    # create_references(swot, references_unsafe_hash)

    redirect_to(peste_path(peste))
  end

  private

  def peste_fields
    fields = params.require(:peste)

    attachments = fields[:attachments]
    fields[:attachment_ids] = upload_files(attachments) if attachments

    fields.permit(
        :peste_type, :name,
        :strategy, :due_at,
        :responsible_id,
        :comments, attachment_ids: []
    )
  end

  def basic_peste_json(peste)
    { object_id: peste.id.to_s, object_name: peste.name }
  end
end
