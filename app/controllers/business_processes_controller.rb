class BusinessProcessesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@process = BusinessProcess.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:process)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    process = BusinessProcess.create!(fields.permit(
        :name,
        :description,
        :process_type,
        :responsible_id,
        :comments,
        attachment_ids: []
    ))

    process.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    create_references(process, params[:references].to_unsafe_h) if params[:references]

    respond_to do |format|
      format.html {
        redirect_to business_process_path(process)
      }
      format.json {
        render json: { object_id: process.id.to_s,
                       object_name: process.name }
      }
    end
  end

  def edit
    if (@process = BusinessProcess.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (process = BusinessProcess.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:process)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    process.update!(fields.permit(
        :process_type,
        :name,
        :description,
        :responsible_id,
        :comments,
        attachment_ids: []
    ))

    process.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    #create_references(process, params[:references].to_unsafe_h) if params[:references]

    redirect_to business_process_path(process)
  end
end
