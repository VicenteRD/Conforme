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
    fields = params.require(:concerned_party)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    concerned_party = ConcernedParty.create!(fields.permit(
        :party_type,
        :name,
        :description,
        :expectation,
        :responsible_id,
        :due_at,
        :comments,
        attachment_ids: []
    ))

    concerned_party.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    create_references(concerned_party, params[:references].to_unsafe_h) if params[:references]

    respond_to do |format|
      format.html { redirect_to concerned_party_path(concerned_party) }
      format.json { render json: {
          object_id: concerned_party.id.to_s,
          object_name: concerned_party.name }
      }
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
    unless (concerned_party = ConcernedParty.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:concerned_party)

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    concerned_party.update!(fields.permit(
        :party_type,
        :name,
        :description,
        :expectation,
        :responsible_id,
        :due_at,
        :comments,
        attachment_ids: []
    ))

    concerned_party.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    #create_references(concerned_party, params[:references].to_unsafe_h) if params[:references]

    redirect_to concerned_party_path(concerned_party)
  end
end
