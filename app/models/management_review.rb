class ManagementReview
  include Mongoid::Document

  include Enumerable

  field :participants_ids, type: Array # BSON::ObjectId => Person::User
  field :findings_ids, type: Array     # BSON::ObjectId => Findings

  field :status, type: String

  field :p_at, as: :planned_for, type: DateTime
  field :e_at, as: :executed_at, type: DateTime

  field :observation, type: String
  field :report, type: String
end
