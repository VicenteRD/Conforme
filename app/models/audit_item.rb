class AuditItem
  include Mongoid::Document

  embedded_in :audit

  field :f_id, as: :finding_id, type: BSON::ObjectId

  field :klass, type: String
  field :element_id, type: BSON::ObjectId

  field :area_id, type: BSON::ObjectId
  field :auditor_id, type: BSON::ObjectId
  field :audited_id, type: BSON::ObjectId

  field :location, type: String
  field :requirement, type: String
  field :hour, type: Integer

  def element
    klass.constantize.find(element_id)
  end

  def finding_resolved?
    return unless finding_id?

    finding = Finding.find(finding_id)

    return unless finding

    finding.step_status
  end
end
