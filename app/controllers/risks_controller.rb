class RisksController < ApplicationController

  include RisksHelper

  def index
    @settings = Settings::RiskSettings.first

    es_type = params[:type].to_sym

    if Risk.get_risk_types.key?(es_type)
      render "risks/index/#{Risk.get_risk_types[es_type][:en]}", layout: 'table'
    elsif Rule.find(params[:type])
      @risks = Risk::RuleRisk.where(rule_id: params[:type]).order_by('get_article_name ASC')
      render 'risks/index/rule', layout: 'table'
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
    elsif (rule = Rule.find(params[:type]))
      @rule = rule
      render 'risks/new/rule', layout: 'form'
    else
      redirect_to '/'
    end
  end

  def create
    fields = params.require(:risk)

    process_name = params.dig(:raw, :process_name)
    if process_name
      id = BusinessProcess.where(name: process_name)
               .pluck(:id).first
      fields[:process_id] = id.to_s if id
    end

    type = params[:type]
    if (klass = Risk.get_risk_types.dig(type.to_sym, :klass))
      if type ==  'ley'
        fields[:rule_type] = 1
      elsif type == 'norma'
        fields[:rule_type] = 2
      end

      redirect_to risk_path create_risk(klass, fields)
    elsif (fields[:rule_type] = Rule.find(type)&.rule_type)
      puts fields.inspect
      redirect_to risk_path create_risk(Risk::RuleRisk, fields)
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

    process_name = params.dig(:raw, :process_name)
    if process_name
      id = BusinessProcess.where(name: process_name)
               .pluck(:id).first
      fields[:process_id] = id.to_s if id
    end

    risk.update!(fields.permit(risk.class.permitted_fields))

    if fields[:associables]
      fields.set_from_hash(fields[:associables])
    end

    risk.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))
    risk.save!

    redirect_to risk_path(risk.id)
  end

  def history
    @book = Risk.find(params[:id]).log_book

    render 'log/show'
  end

  private
  def create_risk(klass, fields)
    entry = params.dig(:log, :body)

    risk = klass.create!(fields.permit(klass.permitted_fields))

    risk.set_from_hash(params[:associables]) if params[:associables]
    risk.log_creation(session[:id], entry.present? ? entry : '')
  end
end
