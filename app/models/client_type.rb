class ClientType
  include Mongoid::Document
  include EnumerableDocument

  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  has_and_belongs_to_many :clients, class_name: 'Person::Client'

  field :name, type: String
  field :desc, as: :description, type: String
end
