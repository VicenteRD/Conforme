class Log::Entry
  include Mongoid::Document

  include Timestamps::Created::Short

  embedded_in :log_book, class_name: 'Log::Book'

  belongs_to :author, class_name: 'Person::User', foreign_key: 'auth_id'

  field :title, type: String
  field :body, type: String
end
