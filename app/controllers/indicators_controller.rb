class IndicatorsController < ApplicationController
  def index
    @indicators = Indicator.all
    render layout: 'table'
  end

  def show
    if (@indicator = Indicator.find(params[:id]))
      render layout: 'show'
    else
      redirect_to '/'
    end
  end

  def new
    render layout: 'form'
  end

  def create
    fields = params.require(:indicator)

    margin = params[:raw][:margin]
    fields[:margin] = margin.to_f / 100.0 if margin

    fields = fields.permit(
        :objective_id,
        :name, :description, :method,
        :threshold, :criterion, :margin,
        :unit, :responsible_id, :measurement_frequency
    )

    redirect_to indicator_path Indicator.create!(fields)
  end

  def edit
    @indicator = Indicator.find(params[:id])

    render layout: 'form'
  end

  def update
    indicator = Indicator.find(params[:id])

    fields = params.require(:indicator)

    margin = params[:raw][:margin]
    fields[:margin] = margin.to_f / 100.0 if margin

    fields = fields.permit(
        :objective_id,
        :name, :description, :method,
        :threshold, :criterion, :margin,
        :unit, :responsible_id, :measurement_frequency
    )

    indicator.update!(fields)
    redirect_to indicator_path(indicator.id)
  end

end
