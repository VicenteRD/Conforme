class UsersController < ApplicationController
  def index
    @person = Person::User.all

    # @settings = Settings::RiskSettings.first
    #
    # es_type = params[:type].to_sym
    #
    # if Risk.get_risk_types.key?(es_type)
    #   klass = Risk.get_risk_types[es_type][:klass]
    #
    #   @risks = klass.order_by(significant: :desc)

      render "users/index", layout: 'table'
    # else
    #   redirect_to '/'
    # end
  end

  def show
    unless (@person = Person::User.find(params[:id]))
      redirect_to '/' and return
    end
    render layout: 'profile'
  end

  def organization_chart

  end

  def eval_competencies

  end

  def eval_performance

  end

  def work_environment

  end
end
