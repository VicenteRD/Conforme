module Describable
  extend ActiveSupport::Concern

  included do
    field :att_ids, as: :attachment_ids, type: Array, default: [] # BSON::ObjectId => UploadedFile
    field :cmts, as: :comments, type: String

    def add_attachments(*attachment_ids)
      self.attachment_ids.append(attachment_ids).flatten!
    end
  end
end