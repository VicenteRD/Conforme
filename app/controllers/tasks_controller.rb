class TasksController < ApplicationController

  def index

    type = params[:type]

    if type == nil
      @tasks = Task.all
    elsif type == 'hallazgos'
      @tasks = Task::FindingTask.all
      render 'tasks/finding/index', layout: 'table'
    elsif type == 'documentos'
      @tasks = Task::DocumentTask.all
      render 'tasks/documents/index', layout: 'table'
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def show_modal
    @task = Task.find(params[:id])
  end

end
