class PlanningsController < ApplicationController

  include DatesHelper

  def index
    render layout: 'table'
  end

  def show
    if (@planning = Planning.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:planning)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))

    planning = Planning.create!(fields.permit(
        :due_at,
        :name,
        :description,
        :comments
    ))
    planning.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    redirect_to planning_path(planning)
  end

  def edit
    if (@planning = Planning.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (planning = Planning.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:planning)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))
    if params.dig(:raw, :executed)&.to_i != 0
      fields[:executed_at] = parse_datetime(params.dig(:raw, :executed_at))
    end
    planning.update!(fields.permit(
        :due_at,
        :executed_at,
        :name,
        :description,
        :comments
    ))
    planning.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    redirect_to planning_path(planning)
  end
end
