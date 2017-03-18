class SwotController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@swot = Swot.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:swot)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    swot = Swot.create!(fields.permit(
        :swot_type,
        :name,
        :strategy,
        :due_at,
        :responsible_id,
        :comments,
        attachment_ids: []
    ))

    swot.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    create_references(swot, params[:references].to_unsafe_h) if params[:references]

    redirect_to(swot_path(swot))
  end

  def edit
    if (@swot = Swot.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (swot = Swot.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:swot)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    swot.update!(fields.permit(
        :swot_type,
        :name,
        :strategy,
        :due_at,
        :responsible_id,
        :comments,
        attachment_ids: []
    ))

    swot.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    #create_references(swot, params[:references].to_unsafe_h) if params[:references]

    redirect_to(swot_path(swot))
  end
end
