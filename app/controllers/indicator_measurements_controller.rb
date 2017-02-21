class IndicatorMeasurementsController < ApplicationController

  before_action :check_permissions, only: [:new, :create, :edit, :update]

  def show_details
    @indicator = Indicator.find(params[:id])

    if @indicator.nil? || !(defined? @indicator.measurements)
      return
    end

    @measurement = @indicator.measurements.find(params[:msrmnt_id])
    if @measurement.nil?
      return
    end

    render 'indicators/measurements/show_comments', layout: false
  end

  def new
    if (@indicator = Indicator.find(params[:indicator_id]))
      render 'indicators/measurements/new', layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    unless (indicator = Indicator.find(params[:indicator_id]))
      redirect_to '/' and return
    end

    fields = params.require(:measurement)

    measured_on = params[:raw][:measured_on]
    fields[:measured_on] = Date.strptime(
        "#{measured_on} #{server_timezone}",
        dt_rb_format
    ) if measured_on
    fields[:threshold] = indicator.threshold

    measurement = indicator.measurements.create!(fields.permit(
        :measured_on,
        :value,
        :threshold
    ))

    measurement.log_book.new_entry(@user.id, 'Creado', params[:log][:entry])

    redirect_to indicator_path(indicator)
  end

  def edit
    if (@indicator = Indicator.find(params[:indicator_id])).nil? ||
        (@measurement = @indicator.measurements.find(params[:id])).nil?
      redirect_to '/' and return
    end

    render 'indicators/measurements/edit', layout: 'form'
  end

  def update
    unless (indicator = Risk.find(params[:indicator_id]))
      redirect_to '/' and return
    end
    unless (measurement = indicator.measurements.find(params[:id]))
      redirect_to '/' and return
    end

    fields = params.require(:measurement)

    measured_on = params[:raw][:measured_on]
    fields[:measured_on] = Date.strptime(
        "#{measured_on} #{server_timezone}",
        dt_rb_format
    ) if measured_on
    fields[:threshold] = indicator.threshold

    measurement.update!(fields.permit(
        :measured_on,
        :value,
        :threshold
    ))
    measurement.log_book.new_entry(@user.id, 'Editado', params[:log][:entry])


    redirect_to indicator_path(indicator)
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

    if params[:indicator_id] && (indicator = Indicator.find(params[:indicator_id]))
      if (user && indicator) && user.id == indicator.responsible_id
        return true
      else
        redirect_to indicator_path(params[:indicator_id]) and return false
      end
    else
      redirect_to '/'
    end
  end
end
