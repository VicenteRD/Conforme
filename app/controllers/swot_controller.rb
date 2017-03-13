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

    swot = Swot.create!(fields.permit(
        :name
    ))

    swot.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    redirect_to(swot_path(swot))
  end

  def edit
    if (@swot = Swot.find(param[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    swot = Swot.find(params[:id])

    fields = params.require(:swot)

    swot.update!(fields.permit(
        :name
    ))

    redirect_to(swot_path(swot))
  end
end
