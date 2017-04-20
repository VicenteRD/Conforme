class ClientTypesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @type = ClientType.find(params[:id])
    redirect_to_dashboard unless @type

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @type = ClientType.find(params[:id])
    redirect_to_dashboard unless @type

    render layout: 'form'
  end

  def create
    type = ClientType.create!(client_type_fields)
    log_created(type)

    create_references(type, references_unsafe_hash)
    add_attachments(type, params.dig(:type, :attachments))

    redirect_to type
  end

  def update
    type = ClientType.find(params[:id])
    redirect_to_dashboard && return unless type

    type.update!(client_type_fields)
    log_edited(type)

    create_references(type, references_unsafe_hash)

    redirect_to type
  end

  def edit_attachments
    type = ClientType.find(params.dig(:attachments, :element_id))
    return unless type

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(type, additions) if additions
    remove_attachments(type.class.name, type, removal_ids) if
        removal_ids

    redirect_to type
  end

  private

  def client_type_fields
    fields = params.require(:type)

    fields.permit(:name, :description, client_ids: [])
  end
end
