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

  def edit
    @peste = Peste.find(params[:id])
    redirect_to_dashboard && return unless @peste

    render layout: 'form'
  end

  def create
    peste = Peste.create!(peste_fields)
    log_created(peste)

    create_references(peste, references_unsafe_hash)
    add_attachments(peste, params.dig(:peste, :attachments))

    respond_to do |format|
      format.html { redirect_to(peste) }
      format.json { render json: peste_as_json(peste) }
    end
  end

  def update
    peste = Peste.find(params[:id])
    redirect_to_dashboard && return unless peste

    peste.update!(peste_fields)
    log_edited(peste)

    create_references(peste, references_unsafe_hash)

    redirect_to peste
  end

  def edit_attachments
    peste = Peste.find(params.dig(:attachments, :element_id))
    return unless peste

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(peste, additions) if additions
    remove_attachments(peste.class.name, peste, removal_ids) if
        removal_ids

    redirect_to peste
  end

  private

  def peste_fields
    fields = params.require(:peste)

    fields.permit(
      :peste_type, :name,
      :strategy, :due_at,
      :responsible_id,
      :comments
    )
  end

  def peste_as_json(peste)
    render json: {
      object_id: peste.id.to_s,
      object_name: peste.name
    }
  end
end
