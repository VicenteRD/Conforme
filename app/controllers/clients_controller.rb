class ClientsController < ApplicationController

  def index
    render layout: 'table'
  end

  def show
    @person = Person::Client.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'profile'
  end

  def new
    render layout: 'form'
  end

  def create
    client = Person::Client.create!(client_fields)

    redirect_to client_path(client)
  end

  def edit
    @person = Person::Client.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'form'
  end

  def update
    client = Person::Client.find(params[:id])
    redirect_to_dashboard && return unless client

    client.update!(client_fields)

    redirect_to client_path(client)
  end

  private

  def client_fields
    fields = params.require(:client)
    fields[:dob] = parse_date(params.dig(:raw, :dob), false)
    fields.permit(
      :rut, :dob,
      :name, :l_name1, :l_name2,
      :email, :phone, :address,
      type_ids: []
    )
  end
end
