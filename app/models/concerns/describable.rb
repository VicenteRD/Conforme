module Describable
  extend ActiveSupport::Concern

  included do
    field :att_id, as: :attachment_id, type: BSON::ObjectId # UploadedFile
    field :cmts, as: :comments, type: String
  end
end