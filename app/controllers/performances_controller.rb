class PerformancesController < ApplicationController
  def create
    performance = Performance.create!(
      params.require(:performance).permit(:phrase)
    )

    respond_to do |format|
      format.json do
        render json: basic_json(performance)
      end
    end
  end

  def basic_json(performance)
    { object_id: performance.id.to_s, object_name: performance.phrase }
  end
end
