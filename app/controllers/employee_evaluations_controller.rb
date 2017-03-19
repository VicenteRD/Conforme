class EmployeeEvaluationsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@evaluation = EmployeeEvaluation.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
  end
end
