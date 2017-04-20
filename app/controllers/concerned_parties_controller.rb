class ConcernedPartiesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @concerned_party = ConcernedParty.find(params[:id])
    redirect_to_dashboard unless @concerned_party

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @concerned_party = ConcernedParty.find(params[:id])
    redirect_to_dashboard unless @concerned_party

    render layout: 'form'
  end

  def create
    concerned_party = ConcernedParty.create!(concerned_party_fields)
    log_created(concerned_party)

    create_references(concerned_party, references_unsafe_hash)
    add_attachments(concerned_party, params.dig(:concerned_party, :attachments))

    respond_to do |format|
      format.html { redirect_to(concerned_party) }
      format.json { concerned_party_as_json(concerned_party) }
    end
  end

  def update
    concerned_party = ConcernedParty.find(params[:id])
    redirect_to_dashboard && return unless concerned_party

    concerned_party.update!(concerned_party_fields)
    log_edited(concerned_party)

    create_references(concerned_party, references_unsafe_hash)

    redirect_to concerned_party
  end

  def edit_attachments
    party = ConcernedParty.find(params.dig(:attachments, :element_id))
    return unless party

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(party, additions) if additions
    remove_attachments(party.class.name, party, removal_ids) if
        removal_ids

    redirect_to party
  end

  private

  def concerned_party_fields
    fields = params.require(:concerned_party)

    fields.permit(
      :party_type,
      :name,
      :description,
      :expectation,
      :responsible_id,
      :due_at,
      :comments
    )
  end

  def concerned_party_as_json(concerned_party)
    render json: {
      object_id: concerned_party.id.to_s,
      object_name: concerned_party.name
    }
  end
end
