class RiskMeasurementsController < ApplicationController

  include RisksHelper
  include DatesHelper

  before_action :check_permissions

  def new
    @settings = Settings::RiskSettings.first

    if (@risk = Risk.find(params[:risk_id])) && (type = minimize_type(@risk._type))
      render "risks/new/measurement/#{type}", layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    unless (risk = Risk.find(params[:risk_id]))
      redirect_to '/' and return
    end

    fields = params.require(:measurement)

    fields[:measured_at] = parse_datetime(params.dig(:raw, :measured_at))

    probability = params.dig(:raw, :probability)
    fields[:probability] = probability.to_f / 100.0 if probability

    compliance = params.dig(:raw, :compliance)
    fields[:compliance] = compliance.to_f / 100.0 if compliance

    if (klass = Risk.get_risk_types.dig(params.dig(:raw, :type).to_sym, :measurement_klass))
      measurement = risk.new_measurement(fields.permit(klass.permitted_fields))
      measurement.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :entry))

      redirect_to risk_path(risk.id)
    else
      redirect_to '/'
    end
  end

  def edit
    @settings = Settings::RiskSettings.first

    if (@risk = Risk.find(params[:risk_id])).nil? ||
        (@measurement = @risk.measurements.find(params[:id])).nil?
      redirect_to '/' and return
    end

    if (type = minimize_type @risk._type)
      render "risks/edit/measurement/#{type}", layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (risk = Risk.find(params[:risk_id]))
      redirect_to '/' and return
    end
    unless (measurement = risk.measurements.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:measurement)

    fields[:measured_at] = parse_datetime(params.dig(:raw, :measured_at))

    probability = params.dig(:raw, :probability)
    fields[:probability] = probability.to_f / 100.0 if probability

    compliance = params.dig(:raw, :compliance)
    fields[:compliance] = compliance.to_f / 100.0 if compliance


    if (klass = Risk.get_risk_types.dig(params.dig(:raw, :type).to_sym, :measurement_klass))
      puts klass.permitted_fields
      measurement.update!(fields.permit(klass.permitted_fields))
      measurement.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :entry))

      risk.update_significant(measurement.significant)

      redirect_to risk_path(risk.id)
    else
      redirect_to '/'
    end
  end

  private

  def check_permissions
    if defined? @user
      user = @user
    elsif session[:id]
      user = Person::User.find(session[:id])
    else
      return false
    end

    if params[:risk_id] && (risk = Risk.find(params[:risk_id]))
      if (user && risk) && user.id == risk.responsible_id
        return true
      else
        redirect_to risk_path(params[:risk_id]) and return false
      end
    else
      redirect_to '/'
    end
  end
end
