class IndicatorMeasurementsController < ApplicationController

  include DatesHelper

  before_action :check_permissions

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

    fields[:measured_at] = parse_datetime(params.dig(:raw, :measured_at))
    fields[:threshold] = indicator.threshold

    measurement = indicator.measurements.create!(fields.permit(
        :measured_at,
        :value,
        :threshold,
        :comments
    ))

    measurement.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :entry))

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
    unless (indicator = Indicator.find(params[:indicator_id]))
      puts 'heyoo'
      redirect_to '/' and return
    end
    unless (measurement = indicator.measurements.find(params[:id]))
      puts 'heyoo2'
      redirect_to '/' and return
    end

    fields = params.require(:measurement)

    fields[:measured_at] = parse_datetime(params.dig(:raw, :measured_at))

    measurement.update!(fields.permit(
        :measured_at,
        :value,
        :threshold,
        :comments
    ))
    measurement.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    puts measurement.log_book.print_all

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
