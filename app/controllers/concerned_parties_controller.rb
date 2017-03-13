class ConcernedPartiesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@concerned_party = BusinessProcess.find(params[:id]))
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

    concerned_party = ConcernedParty.create!(fields.permit(
        :name,
        :description
    ))

    concerned_party.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    redirect_to concerned_party_path(concerned_party)
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

    fields = params.require(:process)

    concerned_party.update!(fields.permit(
        :name,
        :description
    ))

    concerned_party.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    redirect_to concerned_party_path(concerned_party)
  end
end
