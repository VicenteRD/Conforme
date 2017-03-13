class ObjectivesController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@objective = Objective.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:objective)

    objective = Objective.create!(fields.permit(
        :name,
        :description
    ))

    objective.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    redirect_to objective_path(objective)
  end

  def edit
    if (@objective = Objective.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (objective = Objective.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:objective)

    objective.update!(fields.permit(
        :name,
        :description
    ))

    objective.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    redirect_to objective_path(objective)
  end
end
