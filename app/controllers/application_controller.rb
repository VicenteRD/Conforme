class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_login

  def ensure_login
    if session[:id]
      @user = Person::User.find(session[:id])
    else
      redirect_to '/login', status: 302
    end
  end

  def valid_login?
    session[:id]
  end

end
