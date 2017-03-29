class ConcernedPartiesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@concerned_party = ConcernedParty.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    concerned_party = ConcernedParty.create!(concerned_party_fields)

    concerned_party.log_created(current_user_id, log_body)

    create_references(concerned_party, references_unsafe_hash)

    respond_to do |format|
      format.html { redirect_to(concerned_party_path(concerned_party)) }
      format.json { render json: basic_json(concerned_party) }
    end
  end

  def edit
    if (@concerned_party = ConcernedParty.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    concerned_party = ConcernedParty.find(params[:id])
    redirect_to '/' && return unless concerned_party

    concerned_party.update!(concerned_party_fields)
    concerned_party.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    # create_references(concerned_party, params[:references].to_unsafe_h) if params[:references]

    redirect_to concerned_party_path(concerned_party)
  end

  private

  def concerned_party_fields
    fields = params.require(:concerned_party)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    fields.permit(
      :party_type,
      :name,
      :description,
      :expectation,
      :responsible_id,
      :due_at,
      :comments,
      attachment_ids: []
    )
  end

  def basic_json(concerned_party)
    { object_id: concerned_party.id.to_s, object_name: concerned_party.name }
  end
end
