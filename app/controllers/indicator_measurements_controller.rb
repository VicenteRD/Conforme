class IndicatorMeasurementsController < ApplicationController

  before_action :check_permissions

  def new
    @indicator = Indicator.find(params[:indicator_id])
    redirect_to_dashboard && return unless @indicator

    render 'indicators/measurements/new', layout: 'form'
  end

  def edit
    @indicator = Indicator.find(params[:indicator_id])
    redirect_to_dashboard && return unless @indicator
    @measurement = @indicator.measurements.find(params[:id])
    redirect_to_dashboard && return unless @measurement

    render 'indicators/measurements/edit', layout: 'form'
  end

  def create
    indicator = Indicator.find(params[:indicator_id])
    redirect_to_dashboard && return unless indicator

    measurement = indicator.new_measurement(measurement_fields(indicator))
    log_created(measurement)

    indicator_id = indicator.id
    create_references(measurement, references_unsafe_hash, indicator_id)
    add_attachments(
      measurement, params.dig(:measurement, :attachments), indicator_id
    )

    redirect_to indicator
  end

  def update
    indicator = Indicator.find(params[:indicator_id])
    measurement = indicator ? indicator.get_measurement(params[:id]) : nil

    redirect_to_dashboard && return unless measurement

    measurement.update!(measurement_fields(indicator))
    log_edited(measurement)

    create_references(measurement, references_unsafe_hash, indicator.id)

    redirect_to indicator
  end

  private

  def check_permissions
    indicator = Indicator.find(params[:risk_id])

    permitted = indicator && current_user_id == indicator.responsible_id

    redirect_to_dashboard && false unless permitted

    true
  end

  def measurement_fields(indicator)
    fields = params.require(:measurement)

    fields[:measured_at] = parse_date(params.dig(:raw, :measured_at))

    fields[:threshold] = indicator.threshold

    fields.permit(
      :measured_at,
      :value,
      :threshold,
      :comments
    )
  end
end
