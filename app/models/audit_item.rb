class AuditItem
  include Mongoid::Document

  embedded_in :audit

  field :klass, type: String
  field :element_id, type: BSON::ObjectId

  field :area_id, type: BSON::ObjectId
  field :auditor_id, type: BSON::ObjectId
  field :audited_id, type: BSON::ObjectId

  field :location, type: String
  field :requirement, type: String
  field :hour, type: Integer
end
