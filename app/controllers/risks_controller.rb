class RisksController < ApplicationController

  include FormsHelper

  before_action :check_permissions, only: [:new_measurement, :create_measurement]

  def index
    if params[:type]
      if params[:type] == 'gestion'
        @risks = Risk::Operational.all

        render 'risks/operational/index', layout: 'table'
      end
    end
  end

  def show
    @risk = Risk.find(params[:id])
    if @risk != nil
      if @risk._type == 'Risk::Operational'
        render 'risks/operational/show', layout: 'show'
      end
    end
  end

  def history
    @book = Risk.find(params[:id]).log_book

    render 'log/show'
  end

  def new
    if params[:type]
      if params[:type] == 'gestion'
        render 'risks/operational/new', layout: 'application'
      end
    end
  end

  def create
    puts params[:risk]
  end

  def new_measurement
    @risk = Risk.find(params[:id])
    if @risk != nil
      if @risk._type == 'Risk::Operational'
        render 'risks/operational/new_measurement'
      else
        render 'dashboard/index'
      end
    end
  end

  def create_measurement

    val_params = params[:measurement]
    if val_params[:type] == 'operational'
      risk = Risk::Operational.find(params[:id])
      if risk != nil
        risk.new_measurement(session[:id], {measured_at: date_from_hash(val_params, 'measured_at'),
                                            probability: val_params[:probability].to_f / 100.0,
                                            impact: val_params[:impact].to_i,
                                            comments: val_params[:comments]})
      end
    end

    redirect_to risk_path(params[:id])
  end

  def check_permissions
    if defined?(@user)
      user = @user
    elsif session[:id]
      user = Person::User.find(session[:id])
    else
      return
    end

    if params[:id]
      risk = Risk.find(params[:id])
      if user && risk
        if user.id == risk.responsible_id
          return
        else
          redirect_to risk_path(params[:id])
        end
      end
    else
      redirect_to root
    end
  end
end
