class UsersController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@person = Person::User.find(params[:id]))
      render layout: 'profile'
    else
      redirect_to '/'
    end
  end

  def eval_competencies

  end

  def eval_performance

  end

  def work_environment

  end
end
