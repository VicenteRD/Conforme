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

    margin = params.dig(:raw, :margin)
    fields[:margin] = margin.to_f / 100.0 if margin

    indicator = Indicator.create!(fields.permit(
        :objective_id,
        :name, :description, :method,
        :threshold, :criterion, :margin,
        :unit, :responsible_id, :measurement_frequency,
        :comments
    ))

    indicator.log_book.new_entry(@user.id, 'Creado', params.dig(:log, :body))

    redirect_to indicator_path(indicator)
  end

  def edit
    @indicator = Indicator.find(params[:id])

    render layout: 'form'
  end

  def update
    indicator = Indicator.find(params[:id])

    fields = params.require(:indicator)

    margin = params.dig(:raw, :margin)
    fields[:margin] = margin.to_f / 100.0 if margin

    indicator.update!(fields.permit(
        :objective_id,
        :name, :description, :method,
        :threshold, :criterion, :margin,
        :unit, :responsible_id, :measurement_frequency,
        :comments
    ))

    indicator.log_book.new_entry(@user.id, 'Editado', params.dig(:log, :body))

    redirect_to indicator_path(indicator.id)
  end

end
