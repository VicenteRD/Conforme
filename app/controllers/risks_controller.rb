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
    @risk = Risk.find(params[:id])
    type = minimize_type (@risk._type)

    redirect_to_dashboard unless @risk && type

    render "risks/show/#{type}", layout: 'show'
  end

  def new
    @settings = Settings::RiskSettings.first
    type = Risk.risk_types[params[:type].to_sym]

    if type
      render "risks/new/#{type[:en]}", layout: 'form'
    else
      rule = Rule.find(params[:type])
      redirect_to_dashboard && return unless rule

      @rule = rule
      render 'risks/new/rule', layout: 'form'
    end
  end

  def edit
    @settings = Settings::RiskSettings.first
    @risk = Risk.find(params[:id])
    type = minimize_type @risk._type

    redirect_to_dashboard unless @risk && type

    render "risks/edit/#{type}", layout: 'form'
  end

  def create
    fields = params.require(:risk)

    type = params[:type]
    klass = Risk.risk_types.dig(type.to_sym, :klass)

    if klass
      if type == 'ley'
        fields[:rule_type] = 1
      elsif type == 'norma'
        fields[:rule_type] = 2
      end

      redirect_to create_risk(klass, fields)
    else
      rule = Rule.find(type)
      redirect_to_dashboard unless rule

      fields[:rule_type] = rule.rule_type if rule

      redirect_to risk_path(params[:type], create_risk(Risk::RuleRisk, fields))
    end
  end

  def update
    risk = Risk.find(params[:id])
    redirect_to '/' && return unless risk

    fields = params.require(:risk)

    risk.update!(fields.permit(risk.class.permitted_fields))
    log_edited(risk)

    create_references(risk, references_unsafe_hash)
    add_attachments(risk, additions) if additions

    redirect_to risk
  end

  def edit_attachments
    risk = Risk.find(params.dig(:attachments, :element_id))
    return unless risk

    additions = params.dig(:attachments, :additions)
    removal_ids = params.dig(:attachments, :removal_ids)

    remove_attachments(risk.class.name, risk, removal_ids) if removal_ids
    add_attachments(risk, additions) if additions

    redirect_to risk
  end

  private

  def create_risk(klass, fields)
    entry = params.dig(:log, :body)

    risk = klass.create!(fields.permit(klass.permitted_fields, attachment_ids: []))

    create_references(risk, params[:references].to_unsafe_h) if params[:references]
    add_attachments(risk, fields[:attachments]) if fields[:attachments]

    risk.log_creation(session[:id], entry.present? ? entry : '')
  end
end
