class ClientTypesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @type = ClientType.find(params[:id])

    redirect_to '/' unless @type

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def create
    type = ClientType.create!(client_type_fields)

    type.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :entry))

    redirect_to client_type_path(type)
  end

  def edit
    @type = ClientType.find(params[:id])
    redirect_to '/' unless @type

    render layout: 'form'
  end

  def update
    type = ClientType.find(params[:id])
    redirect_to '/' && return unless type

    type.update!(client_type_fields)

    type.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :entry))

    redirect_to client_type_path(type)
  end

  private

  def client_type_fields
    fields = params.require(:type)

    fields.permit(:name, :description, client_ids: [])
  end
end
