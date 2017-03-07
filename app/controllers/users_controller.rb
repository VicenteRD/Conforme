class UsersController < ApplicationController
  def index
    @person = Person::User.all
    render "users/index", layout: 'table'
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
