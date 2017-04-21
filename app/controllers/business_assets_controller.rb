class BusinessAssetsController < ApplicationController

  include DatesHelper

  def index
    @type = parse_job_type(params[:job_type])

    if @type
      render layout: 'table'
    else
      redirect_to_dashboard
    end
  end

  def show
    @type = parse_job_type(params[:job_type])
    @business_asset = BusinessAsset.find(params[:id])

    if @type && @business_asset
      render layout: 'show'
    else
      redirect_to_dashboard
    end
  end

  def new
    @type = parse_job_type(params[:job_type])
    if @type
      render layout: 'form'
    else
      redirect_to_dashboard
    end
  end

  def edit
    @type = parse_job_type(params[:job_type])
    @business_asset = BusinessAsset.find(params[:id])

    if @type && @business_asset
      render layout: 'form'
    else
      redirect_to_dashboard
    end
  end

  def create
    business_asset = BusinessAsset.create!(business_asset_fields)
    log_created(business_asset)

    create_references(business_asset, references_unsafe_hash)
    add_attachments(business_asset, params.dig(:business_asset, :attachments))

    redirect_to business_asset_path(params[:job_type], business_asset)
  end

  def update
    business_asset = BusinessAsset.find(params[:id])
    redirect_to_dashboard && return unless business_asset

    business_asset.update!(business_asset_fields)
    log_edited(business_asset)

    create_references(business_asset, references_unsafe_hash)

    redirect_to business_asset_path(params[:job_type], business_asset)
  end

  def edit_attachments
    asset = BusinessAsset.find(params.dig(:attachments, :element_id))
    return unless asset

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    add_attachments(asset, additions) if additions
    remove_attachments(asset.class.name, asset, removal_ids) if
        removal_ids

    redirect_to asset
  end

  def create_type
    asset_type = BusinessAssetType.create!(params.require(:asset_type).permit(:name, :description))

    respond_to do |format|
      format.json do
        render json: {
          object_id: asset_type.id.to_s, object_name: asset_type.name
        }
      end
    end
  end

  private

  def parse_job_type(es_type)
    es_type if es_type == 'mantencion' || es_type == 'calibracion'
  end

  def business_asset_fields
    params.require(:business_asset).permit(
      :type_id,
      :name,
      :description,
      :identification,
      :comments,
      :responsible_id
    )
  end
end
