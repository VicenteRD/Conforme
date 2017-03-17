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

    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    fields[:next_maintenance_at] = parse_datetime(params.dig(:raw, :next_maintenance_at))
    fields[:next_calibration_at] = parse_datetime(params.dig(:raw, :next_calibration_at))

    business_asset = BusinessAsset.create!(fields.permit(
        :type_id,
        :name,
        :description,
        :identification,
        :comments,
        :responsible_id,
        attachment_ids: []
    ))

    business_asset.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    create_references(business_asset, params[:references].to_unsafe_h) if params[:references]

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

    fields[:next_maintenance_at] = parse_datetime(params.dig(:raw, :next_maintenance_at))
    fields[:next_calibration_at] = parse_datetime(params.dig(:raw, :next_calibration_at))

    business_asset.update!(fields.permit(
        :type_id,
        :name,
        :description,
        :identification,
        :comments,
        :responsible_id,
        attachment_ids: []
    ))

    business_asset.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    #create_references(business_asset, params[:references].to_unsafe_h) if params[:references]

    redirect_to business_asset_path(params[:job_type], business_asset)
  end

  def create_type
    asset_type = BusinessAssetType.create!(params.require(:asset_type).permit(:name, :description))

    respond_to do |format|
      format.json { render json: { object_id: asset_type.id, object_name: asset_type.name } }
    end
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
