module Describable
  extend ActiveSupport::Concern

  included do
    field :att_ids, as: :attachment_ids, type: Array # BSON::ObjectId => UploadedFile
    field :cmts, as: :comments, type: String
  end
end