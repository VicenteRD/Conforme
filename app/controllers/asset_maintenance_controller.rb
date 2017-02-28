class AssetMaintenanceController < ApplicationController

  # Shows a table of all assets with their maintenance info
  def index
    render '/assets/index/maintenance', layout: 'table'
  end

  # Shows an asset's info and a table of maintenance jobs
  def show
    if (@asset = Asset.find(params[:id]))
      render '/assets/show/maintenance', layout: 'show'
    else
      redirect_to '/'
    end
  end

  # Maintenance C/U

  def new

  end

  def create

  end

  def edit

  end

  def update

  end
end
