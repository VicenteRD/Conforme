class SwotController < ApplicationController
  def index

  end

  def show
    if (@swot = Swot.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end
end
