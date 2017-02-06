class AssociablesController < ApplicationController

  include AssociablesHelper

  def list
    @association_key = class_as_key(params[:name].constantize).to_s.split('/').to_a.last
    @element = params[:element].to_sym

    render layout: false
  end

end
