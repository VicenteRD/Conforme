class Log::Entry
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short

  embedded_in :log_book, class_name: 'Log::Book'

  field :a_id, as: :author_id, type: BSON::ObjectId

  field :title, type: String
  field :body, type: String
end
