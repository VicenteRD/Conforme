class AssociablesController < ApplicationController

  include AssociablesHelper

  def list
    @association_key = class_as_key(params[:name].constantize).to_s
    @element = params[:element].to_sym

    render layout: false
  end

end
