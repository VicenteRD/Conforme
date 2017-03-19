class ProviderEvaluationsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@evaluation = ProviderEvaluation.find(params[:id]))
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
