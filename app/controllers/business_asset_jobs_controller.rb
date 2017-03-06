class BusinessAssetJobsController < ApplicationController

  include DatesHelper

  def new
    if (@type = parse_job_type(params[:job_type])) &&
        (@business_asset = BusinessAsset.find(params[:asset_id]))
      render 'business_assets/jobs/new', layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    unless (business_asset = BusinessAsset.find(params[:asset_id]))
      redirect_to '/' and return
    end

    fields = params.require(:asset_job)

    # Parse the parameter job_type into an integer that can be stored
    fields[:job_type] = if params[:job_type] == 'mantencion'
                          1
                        elsif params[:job_type] == 'calibracion'
                          2
                        end

    fields[:executed_at] = parse_datetime(params.dig(:raw, :executed_at))

    job = business_asset.jobs.create!(fields.permit(
        :job_type,
        :executed_at,
        :motive,
        :result,
        :comments
    ))

    job.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :entry))

    redirect_to business_asset_path(params[:job_type], business_asset)
  end

  def edit
    if (@type = parse_job_type(params[:job_type])) &&
        (@business_asset = BusinessAsset.find(params[:asset_id])) &&
        (@job = @business_asset.jobs.find(params[:id]))
      render 'business_assets/jobs/edit', layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (business_asset = BusinessAsset.find(params[:asset_id]))
      redirect_to '/' and return
    end

    unless (job = business_asset.jobs.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:asset_job)

    fields[:executed_at] = parse_datetime(params.dig(:raw, :executed_at))

    job.update!(fields.permit(
            :executed_at,
            :motive,
            :result,
            :comments
    ))

    job.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

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
