class ProviderTypesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @type = ProviderType.find(params[:id])

    redirect_to '/' unless @type

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def create
    type = ProviderType.create!(provider_type_fields)

    type.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :entry))

    redirect_to provider_type_path(type)
  end

  def edit
    @type = ProviderType.find(params[:id])

    redirect_to '/' unless @type

    render layout: 'form'
  end

  def update
    type = ProviderType.find(params[:id])
    redirect_to '/' && return unless type

    type.update!(provider_type_fields)

    type.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :entry))

    redirect_to provider_type_path(type)
  end

  private

  def provider_type_fields
    fields = params.require(:type)

    fields.permit(:name, :description,
                  competency_ids: [], performance_ids: [],
                  provider_ids: [])
  end
end
