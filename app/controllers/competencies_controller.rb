class CompetenciesController < ApplicationController
  def create
    competency = Competency.create!(
      params.require(:competency).permit(:phrase)
    )

    respond_to do |format|
      format.json do
        render json: basic_json(competency)
      end
    end
  end

  def basic_json(competency)
    { object_id: competency.id.to_s, object_name: competency.phrase }
  end
end
