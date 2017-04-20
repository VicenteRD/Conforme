class QualificationsController < ApplicationController
  def create
    qualification = Qualification.create!(
      params.require(:qualification).permit(
        :qualification_type,
        :phrase
      )
    )

    respond_to do |format|
      format.json { qualification_as_json(qualification) }
    end
  end

  def qualification_as_json(qualification)
    render json: {
      object_id: qualification.id.to_s,
      object_name: qualification.phrase
    }
  end
end
