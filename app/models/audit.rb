class Audit
  include Mongoid::Document

  field :program_number, type: Integer

  field :responsible, type: BSON::ObjectId # => Person::User
  field :a_at, as: :date, type: DateTime

  field :positions_ids, type: Array # BSON::ObjectId => Position

  field :status, type: String
  field :objective, type: String
end
