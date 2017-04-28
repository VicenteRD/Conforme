class Definition
  include Mongoid::Document

  include Referable
  include EnumerableDocument
  include Describable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :name, type: String

  field :def, as: :definition, type: String
end
