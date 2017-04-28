class DefinitionsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @definition = Definition.find(params[:id])
    redirect_to_dashboard unless @definition

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @definition = Definition.find(params[:id])
    redirect_to_dashboard unless @definition

    render layout: 'form'
  end

  def create
    definition = Definition.create!(definition_fields)
    log_created(definition)

    create_references(definition, references_unsafe_hash)
    add_attachments(definition, params.dig(:objective, :attachments))

    respond_to do |format|
      format.html { redirect_to(definition) }
      format.json { definition_as_json(definition) }
    end
  end

  def update
    definition = Definition.find(params[:id])
    redirect_to_dashboard && return unless definition

    definition.update!(definition_fields)
    log_edited(definition)

    create_references(definition, references_unsafe_hash)

    redirect_to definition
  end

  def edit_attachments
    definition = Definition.find(params.dig(:attachments, :element_id))
    return unless definition

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(definition, additions) if additions
    remove_attachments(definition.class.name, definition, removal_ids) if
        removal_ids

    redirect_to definition
  end

  private

  def definition_as_json(definition)
    render json: {
      object_id: definition.id.to_s,
      object_name: definition.name
    }
  end

  def definition_fields
    fields = params.require(:definition)

    fields.permit(
      :name,
      :definition,
      :comments
    )
  end
end
