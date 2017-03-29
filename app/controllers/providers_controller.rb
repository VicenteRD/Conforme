class ProvidersController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@person = Person::Provider.find(params[:id]))
      render layout: 'profile'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    Person::Provider.create!(provider_fields)
  end

  def edit
    @person = Person::Provider.find(params[:id])
    redirect_to_dashboard unless @person

    render layout: 'form'
  end

  def update
    unless (provider = Person::Provider.find(params[:id]))
      redirect_to_dashboard && return
    end

    provider.update!
  end

  private

  def provider_fields
    fields = params.require(:client)
    fields[:dob] = parse_date(params.dig(:raw, :dob))
    fields.permit(
      :rut, :dob,
      :name, :l_name1, :l_name2,
      :email, :phone, :address
    )
  end
end
