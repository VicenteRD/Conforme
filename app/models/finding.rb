class Finding
  include Mongoid::Document

  # 'Found at'
  field :f_at, as: :found_at, type: DateTime
  # Finding Type ; might need to swap to subclasses
  field :finding_type, type: String

  field :attachments, type: Array # BSON::ObjectId => UploadedFiles

  field :origin, type: String

end
