class BusinessProcessesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @process = BusinessProcess.find(params[:id])
    redirect_to_dashboard unless @process

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @process = BusinessProcess.find(params[:id])
    redirect_to_dashboard unless @process

    render layout: 'form'
  end

  def create
    process = BusinessProcess.create!(business_process_fields)
    log_created(process)

    create_references(process, references_unsafe_hash)
    add_attachments(process, params.dig(:process, :attachments))

    respond_to do |format|
      format.html { redirect_to(process) }
      format.json { process_as_json(process) }
    end
  end

  def update
    process = BusinessProcess.find(params[:id])
    redirect_to_dashboard && return unless process

    process.update!(business_process_fields)
    log_edited(process)

    create_references(process, references_unsafe_hash)

    redirect_to process
  end

  def edit_attachments
    process = BusinessProcess.find(params.dig(:attachments, :element_id))
    return unless process

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(process, additions) if additions
    remove_attachments(process.class.name, process, removal_ids) if
        removal_ids

    redirect_to process
  end

  private

  def business_process_fields
    params.require(:process).permit(
      :process_type,
      :name,
      :description,
      :responsible_id,
      :comments
    )
  end

  def process_as_json(process)
    render json: { object_id: process.id, object_name: process.name }
  end
end
