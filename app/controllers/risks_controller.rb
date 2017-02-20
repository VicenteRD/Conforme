class RisksController < ApplicationController

  include RisksHelper

  def index
    @settings = Settings::RiskSettings.first

    es_type = params[:type].to_sym

    if Risk.get_risk_types.key?(es_type)
      klass = Risk.get_risk_types[es_type][:klass]

      @risks = klass.order_by(significant: :desc)

      render "risks/index/#{Risk.get_risk_types[es_type][:en]}", layout: 'table'
    else
      redirect_to '/'
    end
  end

  def show
    @settings = Settings::RiskSettings.first

    if (@risk = Risk.find(params[:id])) && (type = minimize_type (@risk._type))
      render "risks/show/#{type}", layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    @settings = Settings::RiskSettings.first

    if (type = Risk.get_risk_types[params[:type].to_sym])
      render "risks/new/#{type[:en]}", layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    fields = params.require(:risk)

    if params[:raw] && params[:raw][:process_name]
      id = BusinessProcess.where(name: params[:raw][:process_name])
               .pluck(:id).first
      fields[:process_id] = id.to_s if id
    end

    if params[:type]
      klass = Risk.get_risk_types[params[:type].to_sym][:klass]
      redirect_to risk_path create_risk(klass, fields)
    else
      redirect_to '/'
    end
  end

  def edit
    @settings = Settings::RiskSettings.first

    if (@risk = Risk.find(params[:id])) && (type = minimize_type @risk._type)
      render "risks/edit/#{type}", layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    fields = params.require(:risk)

    unless (risk = Risk.find(params[:id]))
      redirect_to '/' and return
    end

    if params[:raw] && params[:raw][:process_name]
      id = BusinessProcess.where(name: params[:raw][:process_name])
               .pluck(:id).first
      fields[:process_id] = id.to_s if id
    end

    risk.update!(fields.permit(risk.class.permitted_fields))

    if fields[:associables]
      fields.set_from_hash(fields[:associables])
    end

    risk.log_book.new_entry(@user.id, 'Editado', params[:log][:body])
    risk.save!

    redirect_to risk_path(risk.id)
  end

  def history
    @book = Risk.find(params[:id]).log_book

    render 'log/show'
  end

  private
  def create_risk(klass, fields)
    entry = params[:log][:body]

    risk = klass.create!(fields.permit(klass.permitted_fields))

    risk.set_from_hash(params[:associables]) if params[:associables]
    risk.log_creation(session[:id], entry.present? ? entry : '')
  end
end
