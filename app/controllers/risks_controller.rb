class RisksController < ApplicationController

  include DatesHelper

  before_action :check_permissions, only: [:new_measurement, :create_measurement]


  def risk_operational_risk_path(id)
    risk_path(type = 'gestion', id = id)
  end

  def index
    @settings = Settings::RiskSettings.first

    case params[:type]
      when 'gestion'
        @risks = Risk::OperationalRisk.order_by(significant: :desc)
        type = 'operational'
      when 'ambiente'
        @risks = Risk::EnvironmentalRisk.all
        type = 'environmental'
      when 'seguridad'
        @risks = Risk::SafetyRisk.all
        type = 'safety'
      when 'leyes'
        @risks = Risk::LawRisk.all
        type = 'laws'
      when 'normas'
        @risks = Risk::StandardRisk.all
        type = 'standards'
      else
        type = 'invalid'
        redirect_to '/'
    end

    render "risks/index/#{type}", layout: 'table'
  end

  def show
    @settings = Settings::RiskSettings.first

    @risk = Risk.find(params[:id])
    if @risk.nil?
      redirect_to '/' and return
    end

    type = minimize_type @risk._type

    if type == 'invalid'
        redirect_to '/' and return
    end

    render "risks/show/#{type}", layout: 'show'
  end

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

    case params[:type]
      when 'gestion'
        type = 'operational'
      when 'ambiente'
        type = 'environmental'
      when 'seguridad'
        type = 'safety'
      when 'leyes'
        type = 'laws'
      when 'normas'
        type = 'standards'
      else
        type = 'invalid'
        redirect_to '/' and return
    end

    render "risks/new/#{type}" #, layout: 'new'
  end

  def create
    fields = params[:risk]
    new_risk = nil

    case params[:type]
      when 'gestion'
        new_risk = Risk::OperationalRisk.new(name: fields[:name])
      when 'ambiente'
        new_risk = Risk::EnvironmentalRisk.new(name: fields[:name])
      when 'seguridad'
        new_risk = Risk::SafetyRisk.new(name: fields[:name])
      when 'leyes'
        new_risk = Risk::LawRisk.new(name: fields[:name])
      when 'normas'
        new_risk = Risk::StandardRisk.new(name: fields[:name])
      else
        redirect_to '/' and return
    end

    new_risk.write_attributes(
        measurement_frequency: fields[:measurement_frequency].to_i,
        area_id: fields[:area_id],
        responsible_id: fields[:responsible_id],
        process_id: BusinessProcess.where(name: fields[:process_name]).first.id,
        activity: fields[:activity],
        comments: fields[:comments]
    )
    if fields.key? :associables
      new_risk.set_from_hash(fields[:associables])
    end

    new_risk.save!

    if new_risk
      entry = fields[:log_entry]
      new_risk.created_entry(session[:id], (entry && entry != '') ? entry : '')
    end

    redirect_to risk_path(new_risk.id)
  end

  def edit
    @settings = Settings::RiskSettings.first

    @risk = Risk.find(params[:id])
    if @risk.nil?
      redirect_to '/' and return
    end

    type = minimize_type @risk._type
    if type == 'invalid'
      redirect_to '/' and return
    end

    render "risks/edit/#{type}"
  end

  def update
    risk = Risk.find(params[:id])
    if risk.nil?
      redirect_to '/' and return
    end

    type = minimize_type @risk._type

    proc_id = BusinessProcess.where(name: params[:raw][:process_name])
    fields = params[:risk]

    case type
      when 'gestion'
        # specific fields
      when 'ambiente'
        #
      when 'seguridad'
        #
      when 'leyes'
        #
      when 'normas'
        #
      else
        redirect_to '/' and return
    end

    risk.write_attributes(
            area_id: fields[:area_id],
            process_id: proc_id,
            activity: fields[:activity],
            name: fields[:name],
            responsible_id: fields[:responsible_id],
            measurement_frequency: fields[:measurement_frequency].to_i,
            comments: fields[:comments]
    )
    if fields.key? :associables
      fields.set_from_hash(fields[:associables])
    end

    risk.log_book.new_entry(@user.id, 'Editado', params[:log][:entry])

    risk.save!

    redirect_to risk_path(risk.id)
  end

  def new_measurement
    @settings = Settings::RiskSettings.first

    @risk = Risk.find(params[:id])
    if @risk.nil?
      redirect_to '/' and return
    end

    type = minimize_type @risk._type
    if type == 'invalid'
      redirect_to '/' and return
    end

    render "risks/new/measurement/#{type}"
  end

  def create_measurement
    risk = Risk.find(params[:id])
    if risk.nil?
      redirect_to '/' and return
    end

    val_params = params[:measurement]

    measurement_options = {
        measured_at: DateTime.strptime(val_params[:measured_at] + ' ' + server_timezone, dt_rb_format),
        probability: val_params[:probability].to_f / 100.0,
        comments: val_params[:comments]
    }

    case minimize_type(risk._type)
      when 'operational'
        measurement_options[:impact] = val_params[:impact].to_i
      when 'environmental'
        # TODO
      when 'safety'
        measurement_options[:impact] = val_params[:impact].to_i
      when 'leyes'
        measurement_options[:impact] = val_params[:impact].to_i
      when 'normas'
        measurement_options[:impact] = val_params[:impact].to_i
      else
        redirect_to '/' and return
    end

    measurement = risk.new_measurement(measurement_options)

    measurement.log_book.new_entry(@user.id, 'Creado', params[:log][:entry])


    redirect_to risk_path(risk.id)
  end

  def edit_measurement
    @settings = Settings::RiskSettings.first

    @risk = Risk.find(params[:base_id])

    if @risk.nil?
      redirect_to '/' and return
    end

    puts @risk._type
    type = minimize_type @risk._type
    if type == 'invalid'
      redirect_to '/' and return
    end

    @measurement = @risk.measurements.find(params[:id])

    if @measurement.nil?
      redirect_to '/' and return
    end

    render "risks/edit/measurement/#{type}"
  end

  def update_measurement
    # TODO

    redirect_to risks_path(@risk.id)
  end


  def history
    @book = Risk.find(params[:id]).log_book

    render 'log/show'
  end

  ## Private methods
  private

  def check_permissions
    if defined? @user
      user = @user
    elsif session[:id]
      user = Person::User.find(session[:id])
    else
      return false
    end

    if params[:id]
      begin
        risk = Risk.find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        false
      end

      if (user && risk) && user.id == risk.responsible_id
          return true
      else
          redirect_to risk_path(params[:id])
      end
    else
      redirect_to '/'
    end
  end

  def minimize_type class_name
    case class_name
      when 'Risk::OperationalRisk'
        type = 'operational'
      when 'Risk::EnvironmentalRisk'
        type = 'environmental'
      when 'Risk::SafetyRisk'
        type = 'safety'
      when 'Risk::LawRisk'
        type = 'laws'
      when 'Risk::StandardRisk'
        type = 'standards'
      else
        type = 'invalid'
    end

    type
  end
end
