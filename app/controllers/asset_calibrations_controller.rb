class AssetCalibrationsController < ApplicationController
  def index
    render '/assets/index/calibrations', layout: 'table'
  end

  def show
    if (@asset = Asset.find(params[:id]))
      render '/assets/show/calibrations', layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end
end
