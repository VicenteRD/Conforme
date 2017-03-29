class RiskMeasurementsController < ApplicationController

  include RisksHelper
  include DatesHelper

  before_action :check_permissions

  def new
    @settings = Settings::RiskSettings.first

    @risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless @risk.present?

    render_view('new', @risk._type)
  end

  def create
    risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless risk.present?

    klass = measurement_class(:type)

    if klass
      create_measurement(risk, klass)
      redirect_to_risk(risk)
    else
      redirect_to_dashboard
    end
  end

  def edit
    @settings = Risk.settings

    @risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless @risk.present?
    @measurement = @risk.get_measurement(params[:id])
    redirect_to_dashboard && return unless @measurement.present?

    render_view('edit', @risk._type)
  end

  def update
    risk = Risk.find(params[:risk_id])
    redirect_to_dashboard && return unless risk

    measurement = risk.get_measurement(params[:id])
    klass = measurement_class(:type)

    if measurement && klass
      update_measurement(measurement, risk, klass)
      redirect_to_risk(risk)
    else
      redirect_to_dashboard
    end
  end

  private

  def check_permissions
    if params[:risk_id] && (risk = Risk.find(params[:risk_id])) &&
       @user.id == risk.responsible_id
      true
    else
      redirect_to '/' && false
    end
  end

  def render_view(view_type, risk_type)
    type = minimize_type(risk_type)

    if type
      render("risks/#{view_type}/measurement/#{type}", layout: 'form')
    else
      redirect_to_dashboard
    end
  end

  def create_measurement(risk, klass)
    risk.new_measurement(
      current_user_id,
      measurement_fields.permit(klass.permitted_fields),
      log_entry
    )
  end

  def update_measurement(measurement, risk, klass)
    measurement.update_and_log(
      current_user_id,
      measurement_fields.permit(klass.permitted_fields),
      log_entry
    )

    risk.update_significant(measurement.significant)
  end

  def measurement_fields
    fields = params.require(:measurement)

    fields[:measured_at] = parse_date(params.dig(:raw, :measured_at))
    fields[:probability] = parse_percentage(
        fields, :probability, params.dig(:raw, :probability)
    )
    fields[:compliance] = parse_percentage(
        fields, :compliance, params.dig(:raw, :compliance)
    )

    fields
  end

  def log_entry
    params.dig(:log, :entry)
  end

  def measurement_class(type)
    Risk.measurement_class_for(params.dig(:raw, type))
  end

  def redirect_to_risk(risk)
    redirect_to risk_path(params[:type], risk)
  end
end
