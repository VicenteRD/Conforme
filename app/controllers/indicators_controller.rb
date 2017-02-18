class IndicatorsController < ApplicationController
  def index
    @indicators = Indicators.all
  end
end
