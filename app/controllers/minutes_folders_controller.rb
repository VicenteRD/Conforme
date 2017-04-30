class MinutesFoldersController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    @folder = MinutesFolder.find(params[:id])
    redirect_to_dashboard unless @folder

    render layout: 'show'
  end

  def new
    render layout: 'form'
  end

  def edit
    @folder = MinutesFolder.find(params[:id])
    redirect_to_dashboard unless @folder

    render layout: 'form'
  end

  def create
    folder = MinutesFolder.create!(minutes_folder_fields)
    log_created(folder)

    create_references(folder, references_unsafe_hash)
    process_attachments(folder)

    respond_to do |format|
      format.html { redirect_to(folder) }
      format.json { objective_as_json(folder) }
    end
  end

  def update
    folder = MinutesFolder.find(params[:id])
    redirect_to_dashboard && return unless folder

    folder.update!(minutes_folder_fields)
    log_edited(folder)

    create_references(folder, references_unsafe_hash)
    process_attachments(folder)

    redirect_to folder
  end

  private

  def minutes_folder_as_json(folder)
    render json: {
      object_id: folder.id.to_s,
      object_name: folder.name
    }
  end

  def minutes_folder_fields
    fields = params.require(:folder)

    fields.permit(:name, :location, :comments)
  end

  def process_attachments(folder)
    additions = params.dig(:folder, :new_attachments)
    removals = params.dig(:attachments, :removal_ids)

    add_attachments(folder, additions) if additions
    remove_attachments('MinutesFolder', folder, removals) if removals
  end
end
