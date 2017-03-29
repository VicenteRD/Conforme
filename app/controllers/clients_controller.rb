class ClientsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@person = Person::Client.find(params[:id]))
      render layout: 'profile'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    Person::Client.create!(client_fields)
  end

  def edit
    @person = Person::Client.find(params[:id])
    redirect_to_dashboard unless @person

    render layout: 'form'
  end

  def update
    unless (client = Person::Client.find(params[:id]))
      redirect_to_dashboard and return
    end

    client.update!
  end

  def satisfaction; end

  private

  def client_fields
    fields = params.require(:client)
    fields[:dob] = parse_date(params.dig(:raw, :dob))
    fields.permit(
      :rut, :dob,
      :name, :l_name1, :l_name2,
      :email, :phone, :address
    )
  end
end
