class IndicatorsController < ApplicationController
  def index
    @indicators = Indicator.all
    render layout: 'table'
  end

  def show
    if (@indicator = Indicator.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end
end
