class ReferablesController < ApplicationController

  def render_list
    @reference_key = class_as_key(params[:class_name].constantize)
                     .to_s.split('/').to_a.last
    @extra = params[:extra]

    render layout: false
  end

  private
  def class_as_key(class_type)
    class_type.name.underscore.pluralize.to_sym
  end
end
