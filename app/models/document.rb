class Document
  include Mongoid::Document

  ## Relations
  has_many :read_status
  # belongs_to :position TODO : list of users instad?

  embeds_one :log_book, class_name: 'Log::Book'
end
