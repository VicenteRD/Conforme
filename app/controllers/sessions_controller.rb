class SessionsController < ApplicationController

  def new
    render layout: false
  end

  def create
    @user = Person::User.where(email: params[:session][:email]).first
    if @user && @user.authenticate(params[:session][:password])
      session[:id] = @user.id
      redirect_to '/'
    else
      #redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end
