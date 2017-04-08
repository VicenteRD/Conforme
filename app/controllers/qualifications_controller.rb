class QualificationsController < ApplicationController
  def create
    qualification = Qualification.create!(
      params.require(:qualification).permit(:qualification_type, :phrase)
    )

    respond_to do |format|
      format.json do
        render json: basic_json(qualification)
      end
    end
  end

  def basic_json(qualification)
    { object_id: qualification.id.to_s, object_name: qualification.phrase }
  end
end
