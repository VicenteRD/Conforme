require 'concerns/enumerable_document'

class Risk
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument

  include Associable

  validates_presence_of :area_id, :responsible_id, :process_id

  before_create :init

  embeds_one :log_book, class_name: 'Log::Book'

  field :fq, as: :measurement_frequency, type: Integer

  field :sig, as: :significant, type: Integer

  field :a_id, as: :area_id, type: BSON::ObjectId    # => Position
  field :proc_id, as: :process_id, type: BSON::ObjectId # => BusinessProcess
  field :act, as: :activity, type: String

  field :res_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  field :cmts, as: :comments, type: String

  def init
    self.significant = -1
    self.log_book = Log::Book.new
  end

  def created_entry(author_id, body = '')
    self.log_book.new_entry(author_id, 'Creado', body)
  end

  def new_measurement(significant)
    self.significant = significant
    self.save
  end
end
