class UploadedFile
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include Mongoid::Paperclip

  has_mongoid_attached_file :upload
  validates_attachment_content_type :upload, content_type: %w(
                           application/pdf
                           application/vnd.ms-excel
                           application/msword
                           application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                           application/vnd.openxmlformats-officedocument.wordprocessingml.document
                           text/plain
                           )
  validates_uniqueness_of :upload_file_name
end
