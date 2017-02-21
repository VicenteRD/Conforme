class RiskMeasurementsController < ApplicationController

  include RisksHelper
  include DatesHelper

  before_action :check_permissions, only: [:new, :create, :edit, :update]

  def show_details
    @risk = Risk.find(params[:id])

    if @risk.nil? || !(defined? @risk.measurements)
      return
    end

    @measurement = @risk.measurements.find(params[:msrmnt_id])
    if @measurement.nil?
      return
    end

    render 'risks/show/measurement_comments/show', layout: false
  end

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

    measured_on = params[:raw][:measured_on]
    fields[:measured_at] = DateTime.strptime(
        "#{measured_on} #{server_timezone}",
        dt_rb_format
    ) if measured_on

    probability = params[:raw][:probability]
    fields[:probability] = probability.to_f / 100.0 if probability

    compliance = params[:raw][:compliance]
    fields[:compliance] = compliance.to_f / 100.0 if compliance

    if (klass = Risk.get_risk_types[params[:raw][:type].to_sym][:measurement_klass])
      measurement = risk.new_measurement(fields.permit(klass.permitted_fields))
      measurement.log_book.new_entry(@user.id, 'Creado', params[:log][:entry])

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

    measured_on = params[:raw][:measured_on]
    fields[:measured_at] = DateTime.strptime(
        "#{measured_on} #{server_timezone}",
        dt_rb_format
    ) if measured_on

    probability = params[:raw][:probability]
    fields[:probability] = probability.to_f / 100.0 if probability

    compliance = params[:raw][:compliance]
    fields[:compliance] = compliance.to_f / 100.0 if compliance


    if (klass = Risk.get_risk_types[params[:raw][:type].to_sym][:measurement_klass])
      puts klass.permitted_fields
      measurement.update!(fields.permit(klass.permitted_fields))
      measurement.log_book.new_entry(@user.id, 'Editado', params[:log][:entry])

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
