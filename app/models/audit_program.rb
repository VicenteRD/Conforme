class AuditProgram
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument
  include Referable
  include Describable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :audits

  field :name, type: String
  field :from, type: DateTime
  field :to, type: DateTime

  field :comp, as: :completion, type: Float, default: 0.0

  def completion_percentage
    '0.0'
  end

  def completion_significance
    (0.5 <=> completion) + 1
  end
end
