class UploadedFile
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include Mongoid::Paperclip

  has_mongoid_attached_file :upload
  validates_attachment_content_type :upload, content_type:
      %w(
          application/pdf
          application/vnd.ms-excel
          application/msword
          application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
          application/vnd.openxmlformats-officedocument.wordprocessingml.document
          application/vnd.oasis.opendocument.spreadsheet
          application/vnd.oasis.opendocument.text
          text/plain
      )

  field :attached_to, type: Hash, default: {}

  validates_uniqueness_of :upload_file_name

  # Adds the file to the list of attachments of each element in the given hash
  # as well as adding all the elements to the attached_to hash.
  # The format of the given hash must be:
  #   {:class_name => [doc_ids]}
  # Where:
  #   [doc_keys] => Is the list of document IDs that this file will be attached to.
  #   class_name => Is the name of the class that the documents previously mentioned belong to.
  #                 This class must include Describable.
  #
  def add_as_attachment_to(elements)
    elements.each do |k, v|
      klass = k.constantize
      unless klass < Describable
        return
      end

      v.each do |element_id|
        obj = klass.find(element_id)
        obj.add_attachments(self.id)
        obj.save!
      end

      if self.attached_to[k].nil? || !self.attached_to.key?(k)
        self.attached_to[k] = []
      end

      self.attached_to[k].append(v).flatten!
    end
  end

  def self.all_from(ids)
    files = []
    ids.each do |id|
      uploaded = UploadedFile.find(id)
      files.append(uploaded)
    end

    files
  end
end
