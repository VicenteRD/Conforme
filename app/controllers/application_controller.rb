class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_login

  def ensure_login
    if session[:id]
      begin
        @user = Person::User.find(session[:id])
      rescue Mongoid::Errors::DocumentNotFound
        @user = nil
      end
    end

    if @user.nil?
      redirect_to '/login', status: 302
    end
  end

  def valid_login?
    session[:id]
  end

end
