class UploadedFile
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :path, type: String
end
