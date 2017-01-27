class TasksController < ApplicationController

  def index

    type = params[:tipo]

    if type == nil
      @tasks = Task.all
    else
      # Mad hacky skills here. Watch out.

      type = (type == 'other' ? '' : 'Task::' + type.camelize) + 'Task'

      @tasks = Task.where(_type: type)

    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def show_modal
    @task = Task.find(params[:id])
  end

end
