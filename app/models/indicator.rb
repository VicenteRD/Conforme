class Indicator
  include Mongoid::Document

  include EnumerableDocument

  #has_many :tasks, class_name: 'Indicator::Task'

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :measurements, class_name: 'IndicatorMeasurement'

  belongs_to :objective

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  field :name, type: String
  field :desc, as: :description, type: String
  field :method, type: String # TODO Rename due conflict

  field :thr, as: :threshold, type: Float
  field :mrg, as: :margin, type: Float
  field :crt, as: :criterion, type: String
  field :unit, type: String

  field :cmts, as: :comments, type: String

  field :freq, as: :measurement_frequency, type: Integer

  def init
  end

  def self.get_all_criteria
    %w(≤ < = > ≥)
  end
end
