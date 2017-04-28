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

  def edit
    @person = Person::Client.find(params[:id])
    redirect_to_dashboard && return unless @person

    render layout: 'form'
  end

  def create
    client = Person::Client.create!(client_fields)
    log_created(client)

    client_references(client)
    client_attachments(client, params.dig(:client, :attachments))

    redirect_to client_path(client)
  end

  def update
    client = Person::Client.find(params[:id])
    redirect_to_dashboard && return unless client

    client.update!(client_fields)
    log_edited(client)
    client_references(client)

    redirect_to client_path(client)
  end

  def edit_attachments
    client = Person::Client.find(params.dig(:attachments, :element_id))
    return unless client

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(client, additions) if additions
    remove_attachments(client.class.name, client, removal_ids) if
        removal_ids

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

  def client_references(client)
    create_references(client, params[:references].to_unsafe_h) if
        params[:references]
  end

  def client_attachments(client, attachments)
    add_attachments(client, attachments) if attachments
  end
end
