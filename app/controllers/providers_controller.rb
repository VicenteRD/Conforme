class ProvidersController < ApplicationController

  def index
    render layout: 'table'
  end

  def show
    @person = Person::Provider.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'profile'
  end

  def new
    render layout: 'form'
  end

  def create
    provider = Person::Provider.create!(provider_fields)

    redirect_to provider_path(provider)
  end

  def edit
    @person = Person::Provider.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'form'
  end

  def update
    provider = Person::Provider.find(params[:id])
    redirect_to_dashboard && return unless provider

    provider.update!(provider_fields)

    redirect_to provider_path(provider)
  end

  private

  def provider_fields
    fields = params.require(:provider)
    fields[:dob] = parse_date(params.dig(:raw, :dob), false)
    fields.permit(
      :rut, :dob,
      :name, :l_name1, :l_name2,
      :email, :phone, :address,
      type_ids: []
    )
  end
end
