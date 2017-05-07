class ReferablesController < ApplicationController

  def render_list
    @reference_key = class_as_key(params[:class_name].constantize)
                     .to_s.split('/').to_a.last
    @extra = params[:jsonExtra] ? params[:jsonExtra].to_unsafe_h : params[:extra]

    render layout: false
  end

  def render_list_post
    @reference_key = class_as_key(params[:class_name].constantize)
                         .to_s.split('/').to_a.last
    @extra = params[:jsonExtra] ? params[:jsonExtra].to_unsafe_h : params[:extra]

    render 'referables/render_list', layout: false
  end

  private

  def class_as_key(class_type)
    class_type.name.underscore.pluralize.to_sym
  end
end
