class ProviderTypesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@type = ProviderType.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:type)

    ProviderType.create!(fields.permit(:name))
  end

  def edit
    if (@type = ProviderType.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (type = ProviderType.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:type)

    type.update!(fields.permit(:name))
  end
end
