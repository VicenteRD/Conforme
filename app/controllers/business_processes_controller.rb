class BusinessProcessesController < ApplicationController
  def list
    @element = params[:element].to_sym

    render layout: false
  end

  def new
    @element = params[:element].to_sym

    render layout: false
  end

  def create
    BusinessProcess.create!(name: params[:process][:name], description: params[:process][:description])
  end
end
