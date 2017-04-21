class PlanningActivitiesController < ApplicationController
  def new
    @planning = Planning.find(params[:plan_id])
    redirect_to_dashboard && return unless @planning
    render 'plannings/activities/new', layout: 'form'
  end

  def edit
    @planning = Planning.find(params[:plan_id])
    redirect_to_dashboard && return unless @planning
    @planning_activity = @planning.find_activity(params[:id])
    redirect_to_dashboard && return unless @planning_activity

    render 'plannings/activities/edit', layout: 'form'
  end

  def create
    planning = Planning.find(params[:plan_id])
    redirect_to_dashboard && return unless planning

    activity = planning.new_activity(activity_fields)
    log_created(activity)

    redirect_to planning
  end

  def update
    planning = Planning.find(params[:plan_id])
    activity = planning ? planning.find_activity(params[:id]) : nil

    redirect_to_dashboard && return unless activity

    activity.update!(activity_fields)
    log_edited(activity)

    planning.update_progress

    redirect_to planning
  end

  private

  def activity_fields
    fields = params.require(:planning_activity)

    fields[:due_at] = parse_datetime(params.dig(:raw, :due_at))
    fields[:progress] = parse_percentage(
      fields, :progress, params.dig(:raw, :progress)
    )

    fields[:executed_at] = parse_execution_date

    fields.permit(
      :due_at, :name, :description,
      :progress, :comments
    )
  end

  def parse_execution_date
    exec = params.dig(:raw, :executed)

    parse_date(params.dig(:raw, :executed_at)) if
        exec && exec.to_i != 0
  end
end
