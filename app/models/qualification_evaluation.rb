class QualificationEvaluation
  include Mongoid::Document

  embedded_in :provider_evaluation
  embedded_in :employee_evaluation

  field :q_id, as: :qualification_id, type: BSON::ObjectId

  field :grade, type: Float
  field :cmts, as: :comments, type: String
end
