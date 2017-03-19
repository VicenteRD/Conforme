class ClientsController < ApplicationController
  def index
    render layout: 'table'
  end

  def show
    if (@person = Person::Client.find(params[:id]))
      render layout: 'profile'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    Person::Client.create!
  end

  def edit
    if (@client = Person::Client.find(params[:id]))
      render layout: 'form'
    else
      redirect_to '/'
    end
  end

  def update
    unless (client = Person::Client.find(params[:id]))
      redirect_to '/' and return
    end

    client.update!
  end

  def satisfaction

  end
end
