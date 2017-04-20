class RulesController < ApplicationController
  def create
    rule = Rule.create!(
      params.require(:rule).permit(
        :rule_type,
        :name,
        :institution
      )
    )

    respond_to do |format|
      format.json { rule_as_json(rule) }
    end
  end

  def rule_as_json(rule)
    render json: {
      object_id: rule.id.to_s,
      object_name: rule.name
    }
  end
end
