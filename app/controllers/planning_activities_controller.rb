class PlanningActivitiesController < ApplicationController

  include DatesHelper

  def new
    if (@planning = Planning.find(params[:plan_id]))
      render 'plannings/activities/new', layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    unless (planning = Planning.find(params[:plan_id]))
      redirect_to '/' and return
    end

    fields = params.require(:planning_activity)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))

    progress = params.dig(:raw, :progress)
    fields[:progress] = progress.to_f / 100.0 if progress

    planning_activity = planning.activities.create!(fields.permit(
        :due_at,
        :name,
        :description,
        :progress,
        :comments
    ))
    planning_activity.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :book))

    planning.update_progress

    redirect_to planning_path(planning)
  end

  def edit
    if (@planning = Planning.find(params[:plan_id])) &&
        (@planning_activity = @planning.activities.find(params[:id]))
      render 'plannings/activities/edit', layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (planning = Planning.find(params[:plan_id]))
      redirect_to '/' and return
    end
    unless (planning_activity = planning.activities.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:planning_activity)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))
    fields[:executed_at] = parse_datetime(params.dig(:raw, :executed_at))

    progress = params.dig(:raw, :progress)
    fields[:progress] = progress.to_f / 100.0 if progress

    planning_activity.update!(fields.permit(
        :due_at,
        :executed_at,
        :name,
        :description,
        :progress,
        :comments
    ))
    planning_activity.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :book))

    planning.update_progress

    redirect_to planning_path(planning)
  end
end
