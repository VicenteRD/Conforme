class PositionsController < ApplicationController

  def index
  end

  def show
    @position = Position.find(params[:id])

    render layout: 'show'
  end

  def new

  end
end
