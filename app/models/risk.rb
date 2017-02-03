require 'concerns/enumerable_document'

class Risk
  include Mongoid::Document

  include EnumerableDocument

  include Associable

  before_create :init

  embeds_many :measurements

  embeds_one :log_book, class_name: 'Log::Book'

  field :fq, as: :measurement_frequency, type: Integer

  field :sig, as: :significant, type: Integer

  field :pos_id, as: :position_id, type: BSON::ObjectId    # => Position
  field :res_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  field :proc_id, as: :process_id, type: BSON::ObjectId # => BusinessProcess
  field :act, as: :activity, type: String

  def init
    self.significant = -1
    self.log_book = Log::Book.new
  end

  def created_entry(author_id, body = '')
    self.log_book.new_entry(author_id, 'Creado', body)
  end

  def new_measurement(author_id, significant, comment)
    self.significant = significant
    self.save

    self.log_book.new_entry(author_id, 'Nueva medición', comment)
  end
end
