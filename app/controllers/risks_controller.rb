class RisksController < ApplicationController

  include DatesHelper

  before_action :check_permissions, only: [:new_measurement, :create_measurement]

  def index
    case params[:type]
      when 'gestion'
        @risks = Risk::Operational.order_by(significant: :desc)
        type = 'operational'
      when 'ambiente'
        @risks = Risk::Environmental.all
        type = 'environmental'
      when 'seguridad'
        @risks = Risk::Safety.all
        type = 'safety'
      when 'leyes'
        @risks = Risk::Law.all
        type = 'laws'
      when 'normas'
        @risks = Risk::Standard.all
        type = 'standards'
      else
        type = 'invalid'
        redirect_to '/'
    end

    render "risks/#{type}/index", layout: 'table'
  end

  def show
    begin
      @risk = Risk.find(params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to '/'
    end

    type = minimize_type @risk._type

    if type == 'invalid'
        redirect_to '/'
    end

    render "risks/#{type}/show", layout: 'show'
  end

  def new
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

    render "risks/#{type}/new" #, layout: 'new'
  end

  def create
    new_hash = params[:risk]
    new_risk = nil

    case params[:type]
      when 'gestion'
        new_risk = Risk::Operational.new(name: new_hash[:name])
      when 'ambiente'
        new_risk = Risk::Operational.new(name: new_hash[:name])
      when 'seguridad'
        new_risk = Risk::Safety.new(name: new_hash[:name])
      when 'leyes'
        new_risk = Risk::Law.new(name: new_hash[:name])
      when 'normas'
        new_risk = Risk::Standard.new(name: new_hash[:name])
      else
        redirect_to '/' and return
    end

    new_risk.write_attributes(
        measurement_frequency: new_hash[:frequency].to_i,
        position_id: new_hash[:area],
        responsible_id: new_hash[:responsible],
        process: new_hash[:process],
        activity: new_hash[:activity]
    )
    new_risk.save!

    if new_risk
      entry = new_hash[:log_entry]
      new_risk.created_entry(session[:id], (entry && entry != '') ? entry : '')
    end

    redirect_to risk_path(new_risk.id)
  end

  def new_measurement
    @risk = Risk.find(params[:id])
    if @risk.nil?
      redirect_to '/' and return
    end

    type = minimize_type @risk._type
    if type == 'invalid'
      redirect_to '/'
    end

    render "risks/#{type}/new_measurement"
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

    risk.new_measurement(session[:id], measurement_options)

    redirect_to risk_path(risk.id)
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
      when 'Risk::Operational'
        type = 'operational'
      when 'Risk::Environmental'
        type = 'environmental'
      when 'Risk::Safety'
        type = 'safety'
      when 'Risk::Law'
        type = 'laws'
      when 'Risk::Standard'
        type = 'standards'
      else
        type = 'invalid'
    end

    type
  end
end
