class RiskMeasurementsController < ApplicationController

  include RisksHelper

  before_action :check_permissions

  def new
    @settings = Settings::RiskSettings.first

    @risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless @risk.present?

    render_view('new', @risk._type)
  end

  def edit
    @settings = Risk.settings

    @risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless @risk.present?
    @measurement = @risk.get_measurement(params[:id])
    redirect_to_dashboard && return unless @measurement.present?

    render_view('edit', @risk._type)
  end

  def create
    risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless risk.present?

    klass = measurement_class(:type)

    redirect_to_dashboard && return unless klass

    create_measurement(risk, klass)

    redirect_to risk
  end

  def update
    risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless risk

    measurement = risk.get_measurement(params[:id])
    klass = measurement_class(:type)

    redirect_to_dashboard && return unless measurement && klass

    update_measurement(measurement, risk, klass)

    redirect_to risk
  end

  private

  def check_permissions
    risk = Risk.find(params[:risk_id])

    permitted = risk && current_user_id == risk.responsible_id

    redirect_to_dashboard && false unless permitted

    true
  end

  def render_view(view_type, risk_type)
    type = minimize_type(risk_type)
    redirect_to_dashboard && return unless type

    render("risks/#{view_type}/measurement/#{type}", layout: 'form')
  end

  def create_measurement(risk, klass)
    measurement = risk.new_measurement(
      measurement_fields(klass)
    )
    log_created(measurement)

    create_references(measurement, references_unsafe_hash)
    add_attachments(
      measurement, params.dig(:measurement, :attachments), risk.id
    )
  end

  def update_measurement(measurement, risk, klass)
    measurement.update!(measurement_fields(klass))
    log_edited(measurement)

    # risk.update_significant(measurement.significant)
  end

  def measurement_fields(klass)
    fields = params.require(:measurement)

    fields[:measured_at] = parse_date(params.dig(:raw, :measured_at))
    fields[:probability] = parse_percentage(
      fields, :probability, params.dig(:raw, :probability)
    )
    fields[:compliance] = parse_percentage(
      fields, :compliance, params.dig(:raw, :compliance)
    )

    fields.permit(klass.permitted_fields)
  end

  def measurement_class(type)
    Risk.measurement_class_for(params.dig(:raw, type))
  end
end
