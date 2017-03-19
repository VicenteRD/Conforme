class ProvidersController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@person = Person::Provider.find(params[:id]))
      render layout: 'profile'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    Person::Provider.create!
  end

  def edit
    if (@provider = Person::Provider.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (provider = Person::Client.find(params[:id]))
      redirect_to '/' and return
    end

    provider.update!
  end
end
