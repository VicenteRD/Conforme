class SessionsController < ApplicationController
  skip_before_action :ensure_login

  def new
    render layout: false
  end

  def create
    @user = Person::User.where(email: params[:session][:email]).first
    if @user && @user.authenticate(params[:session][:password])
      session[:id] = @user.id

      session[:keep] = params[:session][:keep]

      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:id] = nil
    redirect_to '/login'
  end
end
