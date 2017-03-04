class BusinessAssetsController < ApplicationController

  include DatesHelper

  def index
    if (@type = parse_job_type(params[:job_type]))
     render layout: 'table'
    else
      redirect_to '/'
    end
  end

  def show
    if (@type = parse_job_type(params[:job_type])) &&
        (@business_asset = BusinessAsset.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    if (@type = parse_job_type(params[:job_type]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    fields = params.require(:business_asset)

    next_maintenance_at = params.dig(:raw, :next_maintenance_at)
    fields[:next_maintenance_at] = DateTime.strptime(
        "#{next_maintenance_at} #{server_timezone}",
        dt_rb_format(true)
    ) if next_maintenance_at
    next_calibration_at = params.dig(:raw, :next_calibration_at)
    fields[:next_calibration_at] = DateTime.strptime(
        "#{next_calibration_at} #{server_timezone}",
        dt_rb_format(true)
    ) if next_calibration_at

    business_asset = BusinessAsset.create!(fields.permit(
        :asset_type,
        :name,
        :comments,
        :next_maintenance_at,
        :next_calibration_at
    ))
    business_asset.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    redirect_to business_asset_path(params[:job_type], business_asset)
  end

  def edit
    if (@type = parse_job_type(params[:job_type])) &&
        (@business_asset = BusinessAsset.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (business_asset = BusinessAsset.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:business_asset)

    next_maintenance_at = params.dig(:raw, :next_maintenance_at)
    fields[:next_maintenance_at] = DateTime.strptime(
        "#{next_maintenance_at} #{server_timezone}",
        dt_rb_format(true)
    ) if next_maintenance_at
    next_calibration_at = params.dig(:raw, :next_calibration_at)
    fields[:next_calibration_at] = DateTime.strptime(
        "#{next_calibration_at} #{server_timezone}",
        dt_rb_format(true)
    ) if next_calibration_at

    business_asset.update!(fields.permit(
        :asset_type,
        :name,
        :comments,
        :next_maintenance_at,
        :next_calibration_at
    ))
    business_asset.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    redirect_to business_asset_path(params[:job_type], business_asset)
  end

  private
  def parse_job_type(es_type)
    if es_type == 'mantencion' || es_type == 'calibracion'
      es_type
    else
      nil
    end
  end
end
