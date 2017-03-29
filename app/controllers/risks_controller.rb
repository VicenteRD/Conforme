class RisksController < ApplicationController

  include RisksHelper

  def index
    @settings = Settings::RiskSettings.first

    es_type = params[:type].to_sym

    if Risk.risk_types.key?(es_type)
      render "risks/index/#{Risk.risk_types[es_type][:en]}", layout: 'table'
    elsif Rule.find(params[:type])
      @risks = Risk::RuleRisk.where(rule_id: params[:type]).order_by(numeral: :asc)
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

    if (type = Risk.risk_types[params[:type].to_sym])
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
    fields[:attachment_ids] = upload_files(fields[:attachments]) if fields[:attachments]

    type = params[:type]
    if (klass = Risk.risk_types.dig(type.to_sym, :klass))
      if type == 'ley'
        fields[:rule_type] = 1
      elsif type == 'norma'
        fields[:rule_type] = 2
      end

      redirect_to risk_path(params[:type], create_risk(klass, fields))
    elsif (fields[:rule_type] = Rule.find(type)&.rule_type)
      redirect_to risk_path(params[:type], create_risk(Risk::RuleRisk, fields))
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

    risk.update!(fields.permit(risk.class.permitted_fields, attachment_ids: []))

    risk.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    #create_references(business_asset, params[:references].to_unsafe_h) if params[:references]

    redirect_to risk_path(params[:type], risk.id)
  end

  private
  def create_risk(klass, fields)
    entry = params.dig(:log, :body)

    risk = klass.create!(fields.permit(klass.permitted_fields, attachment_ids: []))

    create_references(risk, params[:references].to_unsafe_h) if params[:references]

    risk.log_creation(session[:id], entry.present? ? entry : '')
  end
end
