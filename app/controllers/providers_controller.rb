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

  def edit
    @person = Person::Provider.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'form'
  end

  def create
    provider = Person::Provider.create!(provider_fields)
    log_created(provider)

    create_references(provider, references_unsafe_hash)
    add_attachments(provider, params.dig(:provider, :attachments))

    redirect_to provider
  end

  def update
    provider = Person::Provider.find(params[:id])
    redirect_to_dashboard && return unless provider

    provider.update!(provider_fields)
    log_edited(provider)

    create_references(provider, references_unsafe_hash)

    redirect_to provider_path(provider)
  end

  def edit_attachments
    provider = Person::Provider.find(params.dig(:attachments, :element_id))
    return unless provider

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(provider, additions) if additions
    remove_attachments(provider.class.name, provider, removal_ids) if
        removal_ids

    redirect_to provider
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
