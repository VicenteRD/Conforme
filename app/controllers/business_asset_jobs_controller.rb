class BusinessAssetJobsController < ApplicationController
  def new
    @type = parse_job_type(params[:job_type])
    @business_asset = BusinessAsset.find(params[:asset_id])

    redirect_to_dashboard && return unless @type && @business_asset

    render 'business_assets/jobs/new', layout: 'form'
  end

  def edit
    @business_asset = BusinessAsset.find(params[:asset_id])
    redirect_to_dashboard && return unless @business_asset
    @type = parse_job_type(params[:job_type])
    @job = @business_asset.jobs.find(params[:id])

    redirect_to_dashboard && return unless @type && @job

    render 'business_assets/jobs/edit', layout: 'form'
  end

  def create
    asset = BusinessAsset.find(params[:asset_id])
    redirect_to_dashboard && return unless asset

    job = asset.create_job(job_fields)
    log_created(job)

    asset_id = asset.id
    create_references(job, references_unsafe_hash, asset_id)
    add_attachments(
      job, params.dig(:asset_job, :attachments), asset_id
    )

    redirect_to_asset(params[:job_type], asset)
  end

  def update
    asset = BusinessAsset.find(params[:asset_id])
    job = asset ? asset.find_job(params[:id]) : nil

    redirect_to_dashboard && return unless job

    job.update!(job_fields)
    log_edited(job)

    create_references(job, references_unsafe_hash, asset.id)

    redirect_to_asset(params[:job_type], asset)
  end

  private

  def job_fields
    fields = params.require(:asset_job)

    # Parse the parameter job_type into an integer that can be stored
    fields[:job_type] = job_type_to_i(params[:job_type])

    fields[:due_at] = parse_date(params.dig(:raw, :due_at))
    fields[:executed_at] = parse_executed_at

    fields.permit(
      :job_type, :due_at, :executed_at, :motive, :result, :comments
    )
  end

  def redirect_to_asset(job_type, asset)
    redirect_to business_asset_path(job_type, asset)
  end

  def parse_executed_at
    parse_date(params.dig(:raw, :executed_at)) if
        params.dig(:raw, :executed) == '1'
  end

  def parse_job_type(type)
    type if type == 'mantencion' || type == 'calibracion'
  end

  def job_type_to_i(type)
    if type == 'mantencion'
      1
    elsif type == 'calibracion'
      2
    end
  end
end
