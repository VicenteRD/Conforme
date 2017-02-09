class UsersController < ApplicationController
  def index

  end

  def show
    @user = Person::User.find(params[:id])
    if @user.nil?
      redirect_to '/' and return
    end
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
